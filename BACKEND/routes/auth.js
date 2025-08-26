const express = require('express');
const router = express.Router();
const { login, getProfile, changePassword, register } = require('../controllers/authController');
const { authenticateToken } = require('../middleware/auth');

// Rutas públicas
router.post('/login', login);
router.post('/register', register);

// Rutas protegidas
router.get('/profile', authenticateToken, getProfile);
router.put('/change-password', authenticateToken, changePassword);

module.exports = router;
