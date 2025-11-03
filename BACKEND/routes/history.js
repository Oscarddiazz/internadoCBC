const express = require('express');
const router = express.Router();
const { getAprendicesHistory, getAprendizHistory } = require('../controllers/historyController');
const { authenticateToken, isAdmin, isDelegado } = require('../middleware/auth');

// Todas las rutas requieren autenticación
router.use(authenticateToken);

// Rutas para delegados y administradores
router.get('/aprendices', isAdmin, getAprendicesHistory);
router.get('/aprendices', isDelegado, getAprendicesHistory);
router.get('/aprendiz/:id', isAdmin, getAprendizHistory);
router.get('/aprendiz/:id', isDelegado, getAprendizHistory);

module.exports = router;
