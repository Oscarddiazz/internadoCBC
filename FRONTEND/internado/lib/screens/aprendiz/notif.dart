import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> notifications = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Por ahora usamos datos mock, pero se puede conectar a un endpoint de notificaciones
      // final res = await ApiService.getNotifications();

      // Simulamos carga de notificaciones
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        notifications = [
          {
            'id': 1,
            'title': 'Solicitud de Permiso',
            'user': 'Sistema',
            'time': 'Hace 5 minutos',
            'type': 'permiso',
          },
          {
            'id': 2,
            'title': 'Tarea Dirigida Asignada',
            'user': 'Administrador',
            'time': 'Hace 1 hora',
            'type': 'tarea',
          },
          {
            'id': 3,
            'title': 'Permiso Aprobado',
            'user': 'Administrador',
            'time': 'Hace 2 horas',
            'type': 'permiso',
          },
        ];
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar notificaciones: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff0f4d3),
      body: Column(
        children: [
          // Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.chevron_left,
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Notificaciones',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Notifications List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _errorMessage != null
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadNotifications,
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      )
                      : RefreshIndicator(
                        onRefresh: _loadNotifications,
                        child: ListView.separated(
                          itemCount: notifications.length,
                          separatorBuilder:
                              (context, index) => const SizedBox(height: 24),
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Avatar con icono según tipo
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: _getNotificationColor(
                                        notification['type'],
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _getNotificationIcon(
                                        notification['type'],
                                      ),
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Content
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          notification['title'],
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            height: 1.2,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          notification['user'],
                                          style: const TextStyle(
                                            color: Color(0xff374151),
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          notification['time'],
                                          style: const TextStyle(
                                            color: Color(0xff374151),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'permiso':
        return Colors.blue;
      case 'tarea':
        return Colors.green;
      case 'sistema':
        return Colors.orange;
      default:
        return const Color(0xffc4c4c4);
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'permiso':
        return Icons.assignment;
      case 'tarea':
        return Icons.task;
      case 'sistema':
        return Icons.notifications;
      default:
        return Icons.info;
    }
  }
}
