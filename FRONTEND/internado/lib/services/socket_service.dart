import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../config/network_config.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;
  bool _isConnected = false;
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  
  // Streams para notificaciones
  final StreamController<Map<String, dynamic>> _notificationController = 
      StreamController<Map<String, dynamic>>.broadcast();
  
  final StreamController<bool> _connectionController = 
      StreamController<bool>.broadcast();

  // Getters para los streams
  Stream<Map<String, dynamic>> get notificationStream => _notificationController.stream;
  Stream<bool> get connectionStream => _connectionController.stream;
  
  bool get isConnected => _isConnected;

  // Inicializar el servicio
  Future<void> initialize() async {
    await _initializeNotifications();
    _setupSocket();
  }

  // Configurar notificaciones locales
  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    
    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  // Configurar WebSocket para producción
  void _setupSocket() {
    final serverUrl = NetworkConfig.baseUrl.replaceAll('/api', '');
    
    _socket = IO.io(serverUrl, IO.OptionBuilder()
        .setTransports(['websocket', 'polling'])
        .enableAutoConnect()
        .setTimeout(20000) // 20 segundos timeout
        .setReconnectionAttempts(5) // 5 intentos de reconexión
        .setReconnectionDelay(2000) // 2 segundos entre intentos
        .enableForceNew()
        .build());

    _socket!.onConnect((_) {
      print('🔌 [PRODUCCIÓN] Conectado al servidor WebSocket en tiempo real');
      _isConnected = true;
      _connectionController.add(true);
    });

    _socket!.onDisconnect((_) {
      print('🔌 [PRODUCCIÓN] Desconectado del servidor WebSocket');
      _isConnected = false;
      _connectionController.add(false);
    });

    _socket!.onConnectError((error) {
      print('❌ [PRODUCCIÓN] Error de conexión WebSocket: $error');
      _isConnected = false;
      _connectionController.add(false);
    });

    _socket!.onReconnect((_) {
      print('🔄 [PRODUCCIÓN] Reconectado al servidor WebSocket');
      _isConnected = true;
      _connectionController.add(true);
    });

    // Escuchar eventos de notificaciones
    _setupNotificationListeners();
  }

  // Configurar listeners de notificaciones
  void _setupNotificationListeners() {
    // Nueva tarea
    _socket!.on('new_task', (data) {
      _handleNotification('new_task', data);
    });

    // Tarea completada
    _socket!.on('task_completed', (data) {
      _handleNotification('task_completed', data);
    });

    // Nuevo permiso
    _socket!.on('new_permission', (data) {
      _handleNotification('new_permission', data);
    });

    // Respuesta a permiso
    _socket!.on('permission_response', (data) {
      _handleNotification('permission_response', data);
    });

    // Alerta del sistema
    _socket!.on('system_alert', (data) {
      _handleNotification('system_alert', data);
    });

    // Usuario en línea
    _socket!.on('user_online', (data) {
      _handleNotification('user_online', data);
    });

    // Usuario fuera de línea
    _socket!.on('user_offline', (data) {
      _handleNotification('user_offline', data);
    });
  }

  // Manejar notificaciones
  void _handleNotification(String event, Map<String, dynamic> data) {
    print('🔔 Notificación recibida: $event');
    
    // Enviar al stream
    _notificationController.add({
      'event': event,
      'data': data,
    });

    // Mostrar notificación local
    _showLocalNotification(data);
  }

  // Mostrar notificación local
  Future<void> _showLocalNotification(Map<String, dynamic> data) async {
    final String title = data['title'] ?? 'Notificación';
    final String message = data['message'] ?? '';
    final String type = data['type'] ?? 'info';

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'internado_notifications',
      'Notificaciones del Sistema',
      channelDescription: 'Notificaciones del sistema de internado',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      message,
      notificationDetails,
    );
  }

  // Autenticar usuario
  void authenticateUser(int userId, String userRole) {
    if (_socket != null && _isConnected) {
      _socket!.emit('authenticate', {
        'userId': userId,
        'userRole': userRole,
      });
      print('🔐 Usuario autenticado: $userId ($userRole)');
    }
  }

  // Unirse a notificaciones
  void joinNotifications(int userId) {
    if (_socket != null && _isConnected) {
      _socket!.emit('join_notifications', {'userId': userId});
    }
  }

  // Salir de notificaciones
  void leaveNotifications(int userId) {
    if (_socket != null && _isConnected) {
      _socket!.emit('leave_notifications', {'userId': userId});
    }
  }

  // Conectar manualmente
  void connect() {
    if (_socket != null && !_isConnected) {
      _socket!.connect();
    }
  }

  // Desconectar
  void disconnect() {
    if (_socket != null && _isConnected) {
      _socket!.disconnect();
    }
  }

  // Manejar tap en notificación
  void _onNotificationTapped(NotificationResponse response) {
    print('🔔 Notificación tocada: ${response.payload}');
    // Aquí puedes manejar la navegación según el tipo de notificación
  }

  // Enviar evento personalizado
  void emit(String event, Map<String, dynamic> data) {
    if (_socket != null && _isConnected) {
      _socket!.emit(event, data);
    }
  }

  // Limpiar recursos
  void dispose() {
    _socket?.dispose();
    _notificationController.close();
    _connectionController.close();
  }
}
