import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'socket_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  final SocketService _socketService = SocketService();
  
  bool _isInitialized = false;
  StreamSubscription<Map<String, dynamic>>? _notificationSubscription;

  // Inicializar el servicio
  Future<void> initialize() async {
    if (_isInitialized) return;

    await _initializeNotifications();
    await _socketService.initialize();
    _setupNotificationListener();
    _isInitialized = true;
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

    // Crear canal de notificaciones para producción
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'internado_alerts',
      'Alertas del Sistema - Producción',
      description: 'Notificaciones en tiempo real del sistema de internado',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
      enableLights: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Configurar listener de notificaciones del WebSocket
  void _setupNotificationListener() {
    _notificationSubscription = _socketService.notificationStream.listen((notification) {
      _handleNotification(notification);
    });
  }

  // Manejar notificaciones en tiempo real
  void _handleNotification(Map<String, dynamic> notification) {
    final String event = notification['event'];
    final Map<String, dynamic> data = notification['data'];

    print('🔔 [PRODUCCIÓN] Notificación recibida: $event');

    switch (event) {
      case 'new_task':
        _showTaskNotification(data);
        break;
      case 'task_completed':
        _showTaskCompletedNotification(data);
        break;
      case 'new_permission':
        _showPermissionNotification(data);
        break;
      case 'permission_response':
        _showPermissionResponseNotification(data);
        break;
      case 'system_alert':
        _showSystemAlert(data);
        break;
      default:
        _showGenericNotification(data);
    }
  }

  // Mostrar notificación de nueva tarea
  void _showTaskNotification(Map<String, dynamic> data) {
    _showNotification(
      id: 1,
      title: '📋 Nueva Tarea Asignada',
      body: data['message'] ?? 'Tienes una nueva tarea pendiente',
      payload: 'task:${data['data']?['tarea_id']}',
    );
  }

  // Mostrar notificación de tarea completada
  void _showTaskCompletedNotification(Map<String, dynamic> data) {
    _showNotification(
      id: 2,
      title: '✅ Tarea Completada',
      body: data['message'] ?? 'Una tarea ha sido completada',
      payload: 'task_completed:${data['data']?['tarea_id']}',
    );
  }

  // Mostrar notificación de nuevo permiso
  void _showPermissionNotification(Map<String, dynamic> data) {
    _showNotification(
      id: 3,
      title: '🔔 Nueva Solicitud de Permiso',
      body: data['message'] ?? 'Hay una nueva solicitud de permiso',
      payload: 'permission:${data['data']?['permiso_id']}',
    );
  }

  // Mostrar notificación de respuesta a permiso
  void _showPermissionResponseNotification(Map<String, dynamic> data) {
    final String response = data['response'] ?? '';
    final String emoji = response == 'aprobado' ? '✅' : '❌';
    
    _showNotification(
      id: 4,
      title: '$emoji Permiso ${response.toUpperCase()}',
      body: data['message'] ?? 'Tu solicitud de permiso ha sido $response',
      payload: 'permission_response:${data['data']?['permiso_id']}',
    );
  }

  // Mostrar alerta del sistema
  void _showSystemAlert(Map<String, dynamic> data) {
    final String level = data['level'] ?? 'info';
    String emoji = 'ℹ️';
    
    switch (level) {
      case 'warning':
        emoji = '⚠️';
        break;
      case 'error':
        emoji = '🚨';
        break;
      case 'success':
        emoji = '✅';
        break;
    }

    _showNotification(
      id: 5,
      title: '$emoji ${data['title'] ?? 'Alerta del Sistema'}',
      body: data['message'] ?? 'Hay una alerta del sistema',
      payload: 'system_alert',
    );
  }

  // Mostrar notificación genérica
  void _showGenericNotification(Map<String, dynamic> data) {
    _showNotification(
      id: 6,
      title: data['title'] ?? 'Notificación',
      body: data['message'] ?? 'Tienes una nueva notificación',
      payload: 'generic',
    );
  }

  // Mostrar notificación local
  Future<void> _showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'internado_alerts',
      'Alertas del Sistema',
      channelDescription: 'Alertas y notificaciones importantes del sistema',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // Mostrar notificación programada (alarma)
  Future<void> scheduleAlarm({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'internado_alerts',
      'Alertas del Sistema',
      channelDescription: 'Alertas y notificaciones importantes del sistema',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails,
      payload: payload,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Cancelar notificación programada
  Future<void> cancelScheduledNotification(int id) async {
    await _notifications.cancel(id);
  }

  // Cancelar todas las notificaciones
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  // Autenticar usuario en WebSocket
  void authenticateUser(int userId, String userRole) {
    _socketService.authenticateUser(userId, userRole);
  }

  // Conectar WebSocket
  void connect() {
    _socketService.connect();
  }

  // Desconectar WebSocket
  void disconnect() {
    _socketService.disconnect();
  }

  // Verificar si está conectado
  bool get isConnected => _socketService.isConnected;

  // Stream de conexión
  Stream<bool> get connectionStream => _socketService.connectionStream;

  // Manejar tap en notificación
  void _onNotificationTapped(NotificationResponse response) {
    print('🔔 Notificación tocada: ${response.payload}');
    
    // Aquí puedes manejar la navegación según el payload
    if (response.payload != null) {
      _handleNotificationTap(response.payload!);
    }
  }

  // Manejar tap en notificación
  void _handleNotificationTap(String payload) {
    final parts = payload.split(':');
    if (parts.length >= 2) {
      final type = parts[0];
      final id = parts[1];
      
      switch (type) {
        case 'task':
          // Navegar a tareas
          print('Navegando a tarea: $id');
          break;
        case 'permission':
          // Navegar a permisos
          print('Navegando a permiso: $id');
          break;
        case 'system_alert':
          // Navegar a alertas
          print('Navegando a alertas del sistema');
          break;
      }
    }
  }

  // Limpiar recursos
  void dispose() {
    _notificationSubscription?.cancel();
    _socketService.dispose();
  }
}
