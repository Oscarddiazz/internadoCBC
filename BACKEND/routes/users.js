const express = require('express');
const router = express.Router();
const { 
  getAllUsers, 
  getUserById, 
  getUserByCedula,
  createUser, 
  updateUser, 
  deleteUser,
  changeUserRole
} = require('../controllers/userController');
const { authenticateToken, isAdmin, isDelegado } = require('../middleware/auth');

// Todas las rutas requieren autenticación
router.use(authenticateToken);

// Rutas para administradores
router.get('/', isAdmin, getAllUsers);
router.get('/:id', isAdmin, getUserById);
router.post('/', isAdmin, createUser);
router.put('/:id', isAdmin, updateUser);
router.put('/:id/role', isAdmin, changeUserRole);
router.delete('/:id', isAdmin, deleteUser);

// Ruta compartida para obtener usuario por cédula
router.get('/cedula/:cedula', isAdmin, getUserByCedula);
router.get('/cedula/:cedula', isDelegado, getUserByCedula);

module.exports = router;
