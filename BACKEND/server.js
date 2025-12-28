const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const http = require('http');
require('dotenv').config({ path: './config.env' });

// Importar configuración de base de datos
const { testConnection } = require('./config/database');

// Importar servicio de WebSocket
const socketService = require('./services/socketService');

// Importar rutas
const authRoutes = require('./routes/auth');
const userRoutes = require('./routes/users');
const taskRoutes = require('./routes/tasks');
const permissionRoutes = require('./routes/permissions');
const historyRoutes = require('./routes/history');

const app = express();
const server = http.createServer(app);
const PORT = process.env.PORT || 3000;

// Configuración de rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 100, // máximo 100 requests por ventana
  message: {
    success: false,
    message: 'Demasiadas solicitudes desde esta IP, intenta de nuevo más tarde'
  }
});

// Middleware de seguridad
app.use(helmet());
app.use(limiter);

// Middleware para CORS - Configuración optimizada
app.use(cors({
  origin: function (origin, callback) {
    // Permitir requests sin origin (aplicaciones móviles, Postman, etc.)
    if (!origin) return callback(null, true);
    
    // Lista de orígenes permitidos con regex para flexibilidad
    const allowedOrigins = [
      /^http:\/\/localhost:\d+$/,
      /^http:\/\/127\.0\.0\.1:\d+$/,
      /^http:\/\/192\.168\.\d+\.\d+:\d+$/,
      /^http:\/\/10\.0\.\d+\.\d+:\d+$/,
      'http://10.0.2.2:3000', // Emulador Android
      'http://10.0.2.2:8080',
      'http://10.0.2.2:8000'
    ];
    
    const isAllowed = allowedOrigins.some(allowedOrigin => {
      if (typeof allowedOrigin === 'string') {
        return allowedOrigin === origin;
      } else if (allowedOrigin instanceof RegExp) {
        return allowedOrigin.test(origin);
      }
      return false;
    });
    
    callback(null, isAllowed);
  },
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS', 'PATCH'],
  allowedHeaders: [
    'Content-Type', 
    'Authorization', 
    'X-Requested-With',
    'Accept',
    'Origin'
  ]
}));

// Middleware para parsear JSON
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Middleware para servir archivos estáticos
app.use('/uploads', express.static('uploads'));

// Ruta principal
app.get('/', (req, res) => {
  res.json({
    success: true,
    message: 'API del Sistema de Gestión de Internado CBC',
    version: '1.0.0',
    endpoints: {
      auth: '/api/auth',
      users: '/api/users',
      tasks: '/api/tasks',
      permissions: '/api/permissions',
      history: '/api/history'
    }
  });
});

// Ruta de estado del servidor
app.get('/health', (req, res) => {
  res.json({
    success: true,
    message: 'Servidor funcionando correctamente',
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

// Configurar rutas de la API
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/tasks', taskRoutes);
app.use('/api/permissions', permissionRoutes);
app.use('/api/history', historyRoutes);

// Middleware para manejar rutas no encontradas
app.use('*', (req, res) => {
  res.status(404).json({
    success: false,
    message: 'Ruta no encontrada'
  });
});

// Middleware para manejar errores
app.use((error, req, res, next) => {
  console.error('Error del servidor:', error);
  res.status(error.status || 500).json({
    success: false,
    message: error.message || 'Error interno del servidor'
  });
});

// Función para iniciar el servidor
const startServer = async () => {
  try {
    // Probar conexión a la base de datos
    const dbConnected = await testConnection();
    if (!dbConnected) {
      console.error('❌ No se pudo conectar a la base de datos');
      process.exit(1);
    }

    // Inicializar WebSocket
    socketService.initialize(server);

    // Iniciar servidor
    server.listen(PORT, '0.0.0.0', () => {
      console.log('\n🚀 ===== SERVIDOR INICIADO =====');
      console.log(`📊 Puerto: ${PORT}`);
      console.log(`🌐 Web: http://localhost:${PORT}`);
      console.log(`📱 Android: http://10.0.2.2:${PORT}`);
      console.log(`💚 Estado: http://localhost:${PORT}/health`);
      console.log(`🔌 WebSocket: ws://localhost:${PORT}`);
      console.log('================================\n');
    });

  } catch (error) {
    console.error('❌ Error iniciando el servidor:', error);
    process.exit(1);
  }
};

// Manejar señales de terminación
process.on('SIGTERM', () => {
  console.log('🛑 Cerrando servidor...');
  process.exit(0);
});

process.on('SIGINT', () => {
  console.log('🛑 Cerrando servidor...');
  process.exit(0);
});

// Iniciar servidor
startServer();