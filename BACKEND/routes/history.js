const express = require('express');
const router = express.Router();
const { getAprendicesHistory, getAprendizHistory } = require('../controllers/historyController');
const { authenticateToken, isDelegadoOrAdmin } = require('../middleware/auth');

// Todas las rutas requieren autenticación
router.use(authenticateToken);

// Rutas para delegados y administradores
router.get('/aprendices', isDelegadoOrAdmin, getAprendicesHistory);
router.get('/aprendiz/:id', isDelegadoOrAdmin, getAprendizHistory);

module.exports = router;
