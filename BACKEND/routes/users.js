const express = require('express');
const router = express.Router();
const { 
  getAllUsers, 
  getUserById, 
  createUser, 
  updateUser, 
  deleteUser 
} = require('../controllers/userController');
const { authenticateToken, isAdmin } = require('../middleware/auth');

// Todas las rutas requieren autenticación
router.use(authenticateToken);

// Rutas para administradores
router.get('/', isAdmin, getAllUsers);
router.get('/:id', isAdmin, getUserById);
router.post('/', isAdmin, createUser);
router.put('/:id', isAdmin, updateUser);
router.delete('/:id', isAdmin, deleteUser);

module.exports = router;
