const express = require('express');
const router = express.Router();
const { 
  getAllTasks, 
  getTaskById, 
  createTask, 
  updateTask, 
  deleteTask,
  completeTask
} = require('../controllers/taskController');
const { authenticateToken, isAdmin, isDelegado } = require('../middleware/auth');

// Todas las rutas requieren autenticación
router.use(authenticateToken);

// Rutas para obtener tareas (todos los roles pueden ver)
router.get('/', getAllTasks);
router.get('/:id', getTaskById);

// Rutas para administradores y delegados
router.post('/', isAdmin, createTask);
router.post('/', isDelegado, createTask);
router.put('/:id', isAdmin, updateTask);
router.put('/:id', isDelegado, updateTask);
router.delete('/:id', isAdmin, deleteTask);

// Ruta para marcar tarea como completada (aprendices pueden completar sus tareas)
router.put('/:id/complete', completeTask);

module.exports = router;
