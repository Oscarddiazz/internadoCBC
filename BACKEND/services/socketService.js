const { Server } = require('socket.io');

class SocketService {
  constructor() {
    this.io = null;
    this.connectedUsers = new Map(); // userId -> socketId
  }

  initialize(server) {
    this.io = new Server(server, {
      cors: {
        origin: process.env.WS_CORS_ORIGIN || "*",
        methods: ["GET", "POST"],
        credentials: true
      },
      transports: ['websocket', 'polling'],
      allowEIO3: true
    });

    this.setupEventHandlers();
    console.log('🔌 WebSocket service initialized in PRODUCTION mode');
    console.log(`📡 CORS Origin: ${process.env.WS_CORS_ORIGIN || "*"}`);
  }

  setupEventHandlers() {
    this.io.on('connection', (socket) => {
      console.log(`👤 Usuario conectado: ${socket.id}`);

      // Usuario se autentica
      socket.on('authenticate', (data) => {
        const { userId, userRole } = data;
        this.connectedUsers.set(userId, socket.id);
        socket.userId = userId;
        socket.userRole = userRole;
        
        // Unir a salas según el rol
        socket.join(`role_${userRole}`);
        socket.join(`user_${userId}`);
        
        console.log(`✅ Usuario ${userId} (${userRole}) autenticado`);
        
        // Notificar que el usuario está en línea
        this.broadcastToRole('Administrador', 'user_online', {
          userId,
          userRole,
          timestamp: new Date().toISOString()
        });
      });

      // Usuario se desconecta
      socket.on('disconnect', () => {
        if (socket.userId) {
          this.connectedUsers.delete(socket.userId);
          console.log(`👋 Usuario ${socket.userId} desconectado`);
          
          // Notificar que el usuario está fuera de línea
          this.broadcastToRole('Administrador', 'user_offline', {
            userId: socket.userId,
            userRole: socket.userRole,
            timestamp: new Date().toISOString()
          });
        }
      });

      // Escuchar eventos de notificaciones
      socket.on('join_notifications', (data) => {
        const { userId } = data;
        socket.join(`notifications_${userId}`);
        console.log(`🔔 Usuario ${userId} se unió a notificaciones`);
      });

      socket.on('leave_notifications', (data) => {
        const { userId } = data;
        socket.leave(`notifications_${userId}`);
        console.log(`🔕 Usuario ${userId} salió de notificaciones`);
      });
    });
  }

  // Enviar notificación a un usuario específico
  sendToUser(userId, event, data) {
    const socketId = this.connectedUsers.get(userId);
    if (socketId) {
      this.io.to(socketId).emit(event, {
        ...data,
        timestamp: new Date().toISOString()
      });
      console.log(`📤 Notificación enviada a usuario ${userId}: ${event}`);
      return true;
    }
    console.log(`❌ Usuario ${userId} no está conectado`);
    return false;
  }

  // Enviar notificación a todos los usuarios de un rol
  broadcastToRole(role, event, data) {
    this.io.to(`role_${role}`).emit(event, {
      ...data,
      timestamp: new Date().toISOString()
    });
    console.log(`📢 Broadcast a rol ${role}: ${event}`);
  }

  // Enviar notificación a todos los usuarios conectados
  broadcastToAll(event, data) {
    this.io.emit(event, {
      ...data,
      timestamp: new Date().toISOString()
    });
    console.log(`📡 Broadcast global: ${event}`);
  }

  // Notificaciones específicas del sistema
  notifyNewTask(taskData) {
    this.broadcastToRole('Aprendiz', 'new_task', {
      type: 'task',
      title: 'Nueva Tarea Asignada',
      message: `Tienes una nueva tarea: ${taskData.tarea_descripcion}`,
      data: taskData
    });
  }

  notifyTaskCompleted(taskData) {
    this.broadcastToRole('Administrador', 'task_completed', {
      type: 'task',
      title: 'Tarea Completada',
      message: `La tarea "${taskData.tarea_descripcion}" ha sido completada`,
      data: taskData
    });
  }

  notifyNewPermission(permissionData) {
    this.broadcastToRole('Administrador', 'new_permission', {
      type: 'permission',
      title: 'Nueva Solicitud de Permiso',
      message: `Nueva solicitud de permiso de ${permissionData.user_name}`,
      data: permissionData
    });
  }

  notifyPermissionResponse(permissionData, response) {
    this.sendToUser(permissionData.permiso_aprendiz_id, 'permission_response', {
      type: 'permission',
      title: response === 'aprobado' ? 'Permiso Aprobado' : 'Permiso Rechazado',
      message: `Tu solicitud de permiso ha sido ${response}`,
      data: permissionData,
      response
    });
  }

  notifySystemAlert(alertData) {
    this.broadcastToAll('system_alert', {
      type: 'alert',
      title: alertData.title || 'Alerta del Sistema',
      message: alertData.message,
      level: alertData.level || 'info', // info, warning, error
      data: alertData
    });
  }

  // Obtener usuarios conectados
  getConnectedUsers() {
    return Array.from(this.connectedUsers.keys());
  }

  // Verificar si un usuario está conectado
  isUserConnected(userId) {
    return this.connectedUsers.has(userId);
  }
}

// Singleton
const socketService = new SocketService();
module.exports = socketService;
