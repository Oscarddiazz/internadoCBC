const bcrypt = require('bcryptjs');
const { executeQuery } = require('../config/database');

// Obtener todos los usuarios
const getAllUsers = async (req, res) => {
  try {
    const { rol, ficha } = req.query;
    let query = 'SELECT user_id, user_num_ident, user_name, user_ape, user_email, user_tel, user_rol, user_discap, etp_form_Apr, user_gen, user_etn, user_img, fec_ini_form_Apr, fec_fin_form_Apr, ficha_Apr, fec_registro FROM usuario';
    let params = [];

    // Filtros opcionales
    if (rol) {
      query += ' WHERE user_rol = ?';
      params.push(rol);
    }

    if (ficha) {
      if (rol) {
        query += ' AND ficha_Apr = ?';
      } else {
        query += ' WHERE ficha_Apr = ?';
      }
      params.push(ficha);
    }

    query += ' ORDER BY user_name, user_ape';

    const users = await executeQuery(query, params);

    res.json({
      success: true,
      data: users
    });

  } catch (error) {
    console.error('Error obteniendo usuarios:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor'
    });
  }
};

// Obtener usuario por ID
const getUserById = async (req, res) => {
  try {
    const { id } = req.params;

    const users = await executeQuery(
      'SELECT user_id, user_num_ident, user_name, user_ape, user_email, user_tel, user_rol, user_discap, etp_form_Apr, user_gen, user_etn, user_img, fec_ini_form_Apr, fec_fin_form_Apr, ficha_Apr, fec_registro FROM usuario WHERE user_id = ?',
      [id]
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
    console.error('Error obteniendo usuario:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor'
    });
  }
};

// Crear nuevo usuario
const createUser = async (req, res) => {
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
    const existingEmail = await executeQuery(
      'SELECT user_id FROM usuario WHERE user_email = ?',
      [user_email]
    );

    if (existingEmail.length > 0) {
      return res.status(400).json({
        success: false,
        message: 'El email ya está registrado'
      });
    }

    // Verificar si el número de identificación ya existe
    const existingId = await executeQuery(
      'SELECT user_id FROM usuario WHERE user_num_ident = ?',
      [user_num_ident]
    );

    if (existingId.length > 0) {
      return res.status(400).json({
        success: false,
        message: 'El número de identificación ya está registrado'
      });
    }

    // Hash de la contraseña
    const hashedPassword = await bcrypt.hash(user_pass, 12);

    // Insertar usuario
    const result = await executeQuery(
      `INSERT INTO usuario (
        user_num_ident, user_name, user_ape, user_email, user_tel, user_pass, 
        user_rol, user_discap, etp_form_Apr, user_gen, user_etn, user_img, 
        fec_ini_form_Apr, fec_fin_form_Apr, ficha_Apr
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        user_num_ident, user_name, user_ape, user_email, user_tel, hashedPassword,
        user_rol, user_discap || 'Ninguna', etp_form_Apr || 'Lectiva', 
        user_gen || 'Masculino', user_etn || 'No Aplica', user_img || 'default.jpg',
        fec_ini_form_Apr, fec_fin_form_Apr, ficha_Apr || 0
      ]
    );

    // Obtener el usuario creado
    const newUser = await executeQuery(
      'SELECT user_id, user_num_ident, user_name, user_ape, user_email, user_tel, user_rol, user_discap, etp_form_Apr, user_gen, user_etn, user_img, fec_ini_form_Apr, fec_fin_form_Apr, ficha_Apr, fec_registro FROM usuario WHERE user_id = ?',
      [result.insertId]
    );

    res.status(201).json({
      success: true,
      message: 'Usuario creado exitosamente',
      data: newUser[0]
    });

  } catch (error) {
    console.error('Error creando usuario:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor'
    });
  }
};

// Actualizar usuario
const updateUser = async (req, res) => {
  try {
    const { id } = req.params;
    const {
      user_name,
      user_ape,
      user_email,
      user_tel,
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

    // Verificar si el usuario existe
    const existingUser = await executeQuery(
      'SELECT user_id FROM usuario WHERE user_id = ?',
      [id]
    );

    if (existingUser.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Usuario no encontrado'
      });
    }

    // Verificar si el email ya existe (excluyendo el usuario actual)
    if (user_email) {
      const existingEmail = await executeQuery(
        'SELECT user_id FROM usuario WHERE user_email = ? AND user_id != ?',
        [user_email, id]
      );

      if (existingEmail.length > 0) {
        return res.status(400).json({
          success: false,
          message: 'El email ya está registrado por otro usuario'
        });
      }
    }

    // Construir query de actualización dinámicamente
    const updateFields = [];
    const updateValues = [];

    if (user_name) {
      updateFields.push('user_name = ?');
      updateValues.push(user_name);
    }
    if (user_ape) {
      updateFields.push('user_ape = ?');
      updateValues.push(user_ape);
    }
    if (user_email) {
      updateFields.push('user_email = ?');
      updateValues.push(user_email);
    }
    if (user_tel !== undefined) {
      updateFields.push('user_tel = ?');
      updateValues.push(user_tel);
    }
    if (user_rol) {
      updateFields.push('user_rol = ?');
      updateValues.push(user_rol);
    }
    if (user_discap !== undefined) {
      updateFields.push('user_discap = ?');
      updateValues.push(user_discap);
    }
    if (etp_form_Apr) {
      updateFields.push('etp_form_Apr = ?');
      updateValues.push(etp_form_Apr);
    }
    if (user_gen) {
      updateFields.push('user_gen = ?');
      updateValues.push(user_gen);
    }
    if (user_etn) {
      updateFields.push('user_etn = ?');
      updateValues.push(user_etn);
    }
    if (user_img) {
      updateFields.push('user_img = ?');
      updateValues.push(user_img);
    }
    if (fec_ini_form_Apr) {
      updateFields.push('fec_ini_form_Apr = ?');
      updateValues.push(fec_ini_form_Apr);
    }
    if (fec_fin_form_Apr) {
      updateFields.push('fec_fin_form_Apr = ?');
      updateValues.push(fec_fin_form_Apr);
    }
    if (ficha_Apr !== undefined) {
      updateFields.push('ficha_Apr = ?');
      updateValues.push(ficha_Apr);
    }

    if (updateFields.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'No se proporcionaron campos para actualizar'
      });
    }

    updateValues.push(id);

    const query = `UPDATE usuario SET ${updateFields.join(', ')} WHERE user_id = ?`;
    await executeQuery(query, updateValues);

    // Obtener el usuario actualizado
    const updatedUser = await executeQuery(
      'SELECT user_id, user_num_ident, user_name, user_ape, user_email, user_tel, user_rol, user_discap, etp_form_Apr, user_gen, user_etn, user_img, fec_ini_form_Apr, fec_fin_form_Apr, ficha_Apr, fec_registro FROM usuario WHERE user_id = ?',
      [id]
    );

    res.json({
      success: true,
      message: 'Usuario actualizado exitosamente',
      data: updatedUser[0]
    });

  } catch (error) {
    console.error('Error actualizando usuario:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor'
    });
  }
};

// Eliminar usuario
const deleteUser = async (req, res) => {
  try {
    const { id } = req.params;

    // Verificar si el usuario existe
    const existingUser = await executeQuery(
      'SELECT user_id FROM usuario WHERE user_id = ?',
      [id]
    );

    if (existingUser.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Usuario no encontrado'
      });
    }

    // Eliminar usuario
    await executeQuery('DELETE FROM usuario WHERE user_id = ?', [id]);

    res.json({
      success: true,
      message: 'Usuario eliminado exitosamente'
    });

  } catch (error) {
    console.error('Error eliminando usuario:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor'
    });
  }
};

module.exports = {
  getAllUsers,
  getUserById,
  createUser,
  updateUser,
  deleteUser
};
