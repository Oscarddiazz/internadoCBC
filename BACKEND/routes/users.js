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
const { authenticateToken, isAdmin, isDelegadoOrAdmin } = require('../middleware/auth');

// Todas las rutas requieren autenticación
router.use(authenticateToken);

// Rutas para administradores
router.get('/', isAdmin, getAllUsers);
router.get('/:id', isAdmin, getUserById);
router.post('/', isAdmin, createUser);
router.put('/:id', isAdmin, updateUser);
router.put('/:id/role', isAdmin, changeUserRole);
router.delete('/:id', isAdmin, deleteUser);

// Rutas para delegados y administradores
router.get('/cedula/:cedula', isDelegadoOrAdmin, getUserByCedula);

module.exports = router;
