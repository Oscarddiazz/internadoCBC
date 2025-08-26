const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { executeQuery } = require('../config/database');
require('dotenv').config({ path: './config.env' });

// Login de usuario
const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    // Validar campos requeridos
    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: 'Email y contraseña son requeridos'
      });
    }

    // Buscar usuario por email
    const users = await executeQuery(
      'SELECT * FROM usuario WHERE user_email = ?',
      [email]
    );

    if (users.length === 0) {
      return res.status(401).json({
        success: false,
        message: 'Credenciales inválidas'
      });
    }

    const user = users[0];

    // Verificar contraseña
    const isValidPassword = await bcrypt.compare(password, user.user_pass);
    
    // Para desarrollo, también permitir contraseñas sin hash
    const isPlainPassword = password === user.user_pass;

    if (!isValidPassword && !isPlainPassword) {
      return res.status(401).json({
        success: false,
        message: 'Credenciales inválidas'
      });
    }

    // Generar token JWT
    const token = jwt.sign(
      { 
        userId: user.user_id,
        email: user.user_email,
        role: user.user_rol
      },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN }
    );

    // Enviar respuesta sin la contraseña
    const { user_pass, ...userWithoutPassword } = user;

    res.json({
      success: true,
      message: 'Login exitoso',
      data: {
        user: userWithoutPassword,
        token
      }
    });

  } catch (error) {
    console.error('Error en login:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor'
    });
  }
};

// Obtener perfil del usuario autenticado
const getProfile = async (req, res) => {
  try {
    const userId = req.user.user_id;

    const users = await executeQuery(
      'SELECT user_id, user_num_ident, user_name, user_ape, user_email, user_tel, user_rol, user_discap, etp_form_Apr, user_gen, user_etn, user_img, fec_ini_form_Apr, fec_fin_form_Apr, ficha_Apr, fec_registro FROM usuario WHERE user_id = ?',
      [userId]
    );

    if (users.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Usuario no encontrado'
      });
    }

    res.json({
      success: true,
      data: users[0]
    });

  } catch (error) {
    console.error('Error obteniendo perfil:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor'
    });
  }
};

// Cambiar contraseña
const changePassword = async (req, res) => {
  try {
    const { currentPassword, newPassword } = req.body;
    const userId = req.user.user_id;

    if (!currentPassword || !newPassword) {
      return res.status(400).json({
        success: false,
        message: 'Contraseña actual y nueva contraseña son requeridas'
      });
    }

    // Obtener usuario actual
    const users = await executeQuery(
      'SELECT user_pass FROM usuario WHERE user_id = ?',
      [userId]
    );

    if (users.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Usuario no encontrado'
      });
    }

    const user = users[0];

    // Verificar contraseña actual
    const isValidPassword = await bcrypt.compare(currentPassword, user.user_pass);
    const isPlainPassword = currentPassword === user.user_pass;

    if (!isValidPassword && !isPlainPassword) {
      return res.status(401).json({
        success: false,
        message: 'Contraseña actual incorrecta'
      });
    }

    // Hash de la nueva contraseña
    const hashedPassword = await bcrypt.hash(newPassword, 12);

    // Actualizar contraseña
    await executeQuery(
      'UPDATE usuario SET user_pass = ? WHERE user_id = ?',
      [hashedPassword, userId]
    );

    res.json({
      success: true,
      message: 'Contraseña actualizada exitosamente'
    });

  } catch (error) {
    console.error('Error cambiando contraseña:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor'
    });
  }
};

// Registro de usuario
const register = async (req, res) => {
  try {
    const {
      user_num_ident,
      user_name,
      user_ape,
      user_email,
      user_tel,
      user_pass,
      user_rol,
      user_discap,
      etp_form_Apr,
      user_gen,
      user_etn,
      user_img,
      fec_ini_form_Apr,
      fec_fin_form_Apr,
      ficha_Apr
    } = req.body;

    // Validar campos requeridos
    if (!user_num_ident || !user_name || !user_ape || !user_email || !user_pass || !user_rol) {
      return res.status(400).json({
        success: false,
        message: 'Los campos número de identificación, nombre, apellido, email, contraseña y rol son requeridos'
      });
    }

    // Verificar si el email ya existe
    const existingUsers = await executeQuery(
      'SELECT user_id FROM usuario WHERE user_email = ?',
      [user_email]
    );

    if (existingUsers.length > 0) {
      return res.status(400).json({
        success: false,
        message: 'El email ya está registrado'
      });
    }

    // Verificar si el número de identificación ya existe
    const existingIdent = await executeQuery(
      'SELECT user_id FROM usuario WHERE user_num_ident = ?',
      [user_num_ident]
    );

    if (existingIdent.length > 0) {
      return res.status(400).json({
        success: false,
        message: 'El número de identificación ya está registrado'
      });
    }

    // Hash de la contraseña
    const hashedPassword = await bcrypt.hash(user_pass, 10);

    // Insertar nuevo usuario
    const result = await executeQuery(
      `INSERT INTO usuario (
        user_num_ident, user_name, user_ape, user_email, user_tel, user_pass,
        user_rol, user_discap, etp_form_Apr, user_gen, user_etn, user_img,
        fec_ini_form_Apr, fec_fin_form_Apr, ficha_Apr
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        user_num_ident,
        user_name,
        user_ape,
        user_email,
        user_tel || null,
        hashedPassword,
        user_rol,
        user_discap || 'Ninguna',
        etp_form_Apr || 'Lectiva',
        user_gen || 'Masculino',
        user_etn || 'No Aplica',
        user_img || 'default.png',
        fec_ini_form_Apr || new Date().toISOString().split('T')[0],
        fec_fin_form_Apr || new Date(Date.now() + 365 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
        ficha_Apr || 0
      ]
    );

    if (result.affectedRows > 0) {
      // Obtener el usuario creado
      const newUser = await executeQuery(
        'SELECT * FROM usuario WHERE user_id = ?',
        [result.insertId]
      );

      // Generar token JWT
      const token = jwt.sign(
        { 
          userId: newUser[0].user_id,
          email: newUser[0].user_email,
          role: newUser[0].user_rol
        },
        process.env.JWT_SECRET,
        { expiresIn: process.env.JWT_EXPIRES_IN }
      );

      // Enviar respuesta sin la contraseña
      const { user_pass, ...userWithoutPassword } = newUser[0];

      res.status(201).json({
        success: true,
        message: 'Usuario registrado exitosamente',
        data: {
          user: userWithoutPassword,
          token
        }
      });
    } else {
      res.status(500).json({
        success: false,
        message: 'Error al crear el usuario'
      });
    }

  } catch (error) {
    console.error('Error en registro:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor'
    });
  }
};

module.exports = {
  login,
  getProfile,
  changePassword,
  register
};
