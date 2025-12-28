const express = require('express');
const router = express.Router();
const { 
  getAllPermissions, 
  getPermissionById, 
  createPermission, 
  respondToPermission,
  deletePermission
} = require('../controllers/permissionController');
const { authenticateToken, isAdmin, isAprendiz } = require('../middleware/auth');

// Todas las rutas requieren autenticación
router.use(authenticateToken);

// Rutas para obtener permisos (todos pueden ver)
router.get('/', getAllPermissions);
router.get('/:id', getPermissionById);

// Ruta para crear permiso (solo aprendices)
router.post('/', isAprendiz, createPermission);

// Rutas para administradores
router.put('/:id/respond', isAdmin, respondToPermission);
router.delete('/:id', isAdmin, deletePermission);

module.exports = router;
