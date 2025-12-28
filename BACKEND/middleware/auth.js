const jwt = require('jsonwebtoken');
const { executeQuery } = require('../config/database');
require('dotenv').config({ path: './config.env' });

// Middleware para verificar token JWT
const authenticateToken = async (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1]; // Bearer TOKEN

  if (!token) {
    return res.status(401).json({ 
      success: false, 
      message: 'Token de acceso requerido' 
    });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    
    // Verificar que el usuario existe en la base de datos
    const user = await executeQuery(
      'SELECT user_id, user_email, user_rol, user_name, user_ape FROM usuario WHERE user_id = ?',
      [decoded.userId]
    );

    if (user.length === 0) {
      return res.status(401).json({ 
        success: false, 
        message: 'Usuario no encontrado' 
      });
    }

    req.user = user[0];
    next();
  } catch (error) {
    console.error('Error verificando token:', error);
    return res.status(403).json({ 
      success: false, 
      message: 'Token inválido o expirado' 
    });
  }
};

// Middleware para verificar roles específicos
const authorizeRoles = (...roles) => {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({ 
        success: false, 
        message: 'Usuario no autenticado' 
      });
    }

    if (!roles.includes(req.user.user_rol)) {
      return res.status(403).json({ 
        success: false, 
        message: 'No tienes permisos para realizar esta acción' 
      });
    }

    next();
  };
};

// Middleware para verificar si es administrador
const isAdmin = authorizeRoles('Administrador');

// Middleware para verificar si es delegado
const isDelegado = authorizeRoles('Delegado');

// Middleware para verificar si es aprendiz
const isAprendiz = authorizeRoles('Aprendiz');

module.exports = {
  authenticateToken,
  authorizeRoles,
  isAdmin,
  isDelegado,
  isAprendiz
};
