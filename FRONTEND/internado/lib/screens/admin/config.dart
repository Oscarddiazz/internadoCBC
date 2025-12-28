//Pantalla de configuración del administrador

import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../config/app_config.dart';

class AdminConfiguracionScreen extends StatelessWidget {
  const AdminConfiguracionScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: const Color(AppConfig.primaryColor),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información del usuario
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(AppConfig.primaryColor),
                          child: Text(
                            AuthService.currentUser?.userName
                                    .substring(0, 1)
                                    .toUpperCase() ??
                                'U',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${AuthService.currentUser?.userName ?? ''} ${AuthService.currentUser?.userApe ?? ''}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                AuthService.currentUser?.userEmail ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(AppConfig.primaryColor),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _getRolText(AuthService.currentUser?.userRol),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Opciones de configuración
            const Text(
              'Opciones de Cuenta',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Opción: Mi Perfil
            _buildConfigOption(
              context,
              icon: Icons.person,
              title: 'Mi Perfil',
              subtitle: 'Ver y editar información personal',
              onTap: () {
                // TODO: Navegar a pantalla de perfil
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Funcionalidad en desarrollo')),
                );
              },
            ),

            // Opción: Cambiar Contraseña
            _buildConfigOption(
              context,
              icon: Icons.lock,
              title: 'Cambiar Contraseña',
              subtitle: 'Actualizar contraseña de acceso',
              onTap: () {
                // TODO: Navegar a pantalla de cambiar contraseña
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Funcionalidad en desarrollo')),
                );
              },
            ),

            // Opción: Notificaciones
            _buildConfigOption(
              context,
              icon: Icons.notifications,
              title: 'Notificaciones',
              subtitle: 'Configurar alertas y notificaciones',
              onTap: () {
                // TODO: Navegar a pantalla de notificaciones
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Funcionalidad en desarrollo')),
                );
              },
            ),

            const SizedBox(height: 24),

            // Opciones del Sistema
            const Text(
              'Sistema',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Opción: Acerca de
            _buildConfigOption(
              context,
              icon: Icons.info,
              title: 'Acerca de',
              subtitle: 'Información de la aplicación',
              onTap: () {
                // TODO: Navegar a pantalla de acerca de
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Funcionalidad en desarrollo')),
                );
              },
            ),

            // Opción: Ayuda
            _buildConfigOption(
              context,
              icon: Icons.help,
              title: 'Ayuda',
              subtitle: 'Guía de uso y soporte',
              onTap: () {
                // TODO: Navegar a pantalla de ayuda
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Funcionalidad en desarrollo')),
                );
              },
            ),

            const Spacer(),

            // Botón de Cerrar Sesión
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showLogoutDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(AppConfig.primaryColor),
          size: 24,
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }

  String _getRolText(dynamic rol) {
    switch (rol?.toString()) {
      case 'RolType.administrador':
        return 'Administrador';
      case 'RolType.delegado':
        return 'Delegado';
      case 'RolType.aprendiz':
        return 'Aprendiz';
      default:
        return 'Usuario';
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar Sesión'),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) async {
    try {
      // Mostrar indicador de carga
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      // Cerrar sesión
      await AuthService.logout(context);

      // Cerrar el diálogo de carga
      Navigator.of(context).pop();

      // Navegar a la pantalla de login
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sesión cerrada correctamente'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Cerrar el diálogo de carga
      Navigator.of(context).pop();

      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cerrar sesión: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
