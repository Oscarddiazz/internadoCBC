import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/welcome_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/register_step2_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/admin/inicio_admin.dart';
import '../screens/admin/aprendices_registrados/aprendiz_registrado.dart';
import '../screens/admin/aprendices_registrados/vista_aprendiz.dart';
import '../screens/configuracion_screen.dart';
import '../screens/admin/permisos/permisos_solicitados.dart';

class AppRoutes {
  // Rutas principales
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String registerStep2 = '/register-step2';
  static const String home = '/home';

  // Rutas de administrador
  static const String adminDashboard = '/admin-dashboard';
  static const String aprendicesRegistrados = '/aprendices-registrados';
  static const String vistaAprendiz = '/vista-aprendiz';

  // Rutas de gestión de usuarios
  static const String gestionUsuarios = '/gestion-usuarios';
  static const String crearUsuario = '/crear-usuario';
  static const String editarUsuario = '/editar-usuario';
  static const String perfilUsuario = '/perfil-usuario';

  // Rutas de gestión de tareas
  static const String gestionTareas = '/gestion-tareas';
  static const String crearTarea = '/crear-tarea';
  static const String editarTarea = '/editar-tarea';
  static const String detalleTarea = '/detalle-tarea';
  static const String misTareas = '/mis-tareas';

  // Rutas de gestión de permisos
  static const String gestionPermisos = '/gestion-permisos';
  // Ruta legible para la UI
  static const String solicitudesPermiso = '/solicitudes-permiso';
  static const String crearPermiso = '/crear-permiso';
  static const String detallePermiso = '/detalle-permiso';
  static const String misPermisos = '/mis-permisos';

  // Rutas de gestión de documentos
  static const String gestionDocumentos = '/gestion-documentos';
  static const String subirDocumento = '/subir-documento';
  static const String verDocumento = '/ver-documento';

  // Rutas de gestión de comidas
  static const String gestionComidas = '/gestion-comidas';
  static const String crearEntregaComida = '/crear-entrega-comida';
  static const String detalleEntregaComida = '/detalle-entrega-comida';

  // Rutas de reportes y estadísticas
  static const String reportes = '/reportes';
  static const String estadisticas = '/estadisticas';

  // Rutas de configuración
  static const String configuracion = '/configuracion';
  static const String perfil = '/perfil';
  static const String cambiarPassword = '/cambiar-password';

  // Rutas de notificaciones
  static const String notificaciones = '/notificaciones';

  // Rutas de ayuda
  static const String ayuda = '/ayuda';
  static const String acercaDe = '/acerca-de';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      // Rutas principales
      splash: (context) => const SplashScreen(),
      welcome: (context) => const WelcomeScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      registerStep2: (context) => const RegisterStep2Screen(),
      home: (context) => const HomeScreen(),

      // Rutas de administrador
      adminDashboard: (context) => AdminDashboard(),
      aprendicesRegistrados: (context) => const AprendicesRegistrados(),
      vistaAprendiz: (context) {
        final args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return StudentProfileScreen(apprenticeData: args);
      },

      // Rutas de gestión de usuarios (placeholder)
      gestionUsuarios: (context) => _buildPlaceholder('Gestión de Usuarios'),
      crearUsuario: (context) => _buildPlaceholder('Crear Usuario'),
      editarUsuario: (context) => _buildPlaceholder('Editar Usuario'),
      perfilUsuario: (context) => _buildPlaceholder('Perfil de Usuario'),

      // Rutas de gestión de tareas (placeholder)
      gestionTareas: (context) => _buildPlaceholder('Gestión de Tareas'),
      crearTarea: (context) => _buildPlaceholder('Crear Tarea'),
      editarTarea: (context) => _buildPlaceholder('Editar Tarea'),
      detalleTarea: (context) => _buildPlaceholder('Detalle de Tarea'),
      misTareas: (context) => _buildPlaceholder('Mis Tareas'),

  // Rutas de gestión de permisos
  gestionPermisos: (context) => const SolicitudesPermiso(),
  solicitudesPermiso: (context) => const SolicitudesPermiso(),
      crearPermiso: (context) => _buildPlaceholder('Crear Permiso'),
      detallePermiso: (context) => _buildPlaceholder('Detalle de Permiso'),
      misPermisos: (context) => _buildPlaceholder('Mis Permisos'),

      // Rutas de gestión de documentos (placeholder)
      gestionDocumentos: (context) =>
          _buildPlaceholder('Gestión de Documentos'),
      subirDocumento: (context) => _buildPlaceholder('Subir Documento'),
      verDocumento: (context) => _buildPlaceholder('Ver Documento'),

      // Rutas de gestión de comidas (placeholder)
      gestionComidas: (context) => _buildPlaceholder('Gestión de Comidas'),
      crearEntregaComida: (context) =>
          _buildPlaceholder('Crear Entrega de Comida'),
      detalleEntregaComida: (context) =>
          _buildPlaceholder('Detalle de Entrega de Comida'),

      // Rutas de reportes y estadísticas (placeholder)
      reportes: (context) => _buildPlaceholder('Reportes'),
      estadisticas: (context) => _buildPlaceholder('Estadísticas'),

      // Rutas de configuración
      configuracion: (context) => const ConfiguracionScreen(),
      perfil: (context) => _buildPlaceholder('Mi Perfil'),
      cambiarPassword: (context) => _buildPlaceholder('Cambiar Contraseña'),

      // Rutas de notificaciones (placeholder)
      notificaciones: (context) => _buildPlaceholder('Notificaciones'),

      // Rutas de ayuda (placeholder)
      ayuda: (context) => _buildPlaceholder('Ayuda'),
      acercaDe: (context) => _buildPlaceholder('Acerca de'),
    };
  }

  // Widget temporal para rutas no implementadas
  static Widget _buildPlaceholder(String title) {
    return Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.construction, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Esta funcionalidad está en desarrollo',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
