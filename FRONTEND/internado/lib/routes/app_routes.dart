import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/welcome_screen.dart';
import '../screens/auth/login_screen.dart';

import '../screens/auth/register_step2_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/admin/inicio_admin.dart';
import '../screens/admin/aprendices_registrados/aprendiz_registrado.dart';
import '../screens/admin/aprendices_registrados/vista_aprendiz.dart';
import '../screens/configuracion_screen.dart';
import '../screens/admin/permisos/permisos_solicitados.dart';
import '../screens/admin/reportes/crear_reporte.dart';
import '../screens/perfil_screen.dart';
import '../screens/nortificaciones_screen.dart';

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
  static const String solicitudesPermiso = '/solicitudes-permiso';

  // Rutas de configuración
  static const String configuracion = '/configuracion';
  static const String perfil = '/perfil';
  static const String notificaciones = '/notificaciones';

  // Rutas de reportes
  static const String crearReporte = '/crear-reporte';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      // Rutas principales
      splash: (context) => const SplashScreen(),
      welcome: (context) => const WelcomeScreen(),
      login: (context) => const LoginScreen(),
      registerStep2: (context) => const RegisterStep2Screen(),
      home: (context) => const InicioAprendiz(),

      // Rutas de administrador
      adminDashboard: (context) => AdminDashboard(),
      aprendicesRegistrados: (context) => const AprendicesRegistrados(),
      vistaAprendiz: (context) {
        final args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return StudentProfileScreen(apprenticeData: args);
      },
      solicitudesPermiso: (context) => const SolicitudesPermiso(),

      // Rutas de configuración
      configuracion: (context) => const ConfiguracionScreen(),
      perfil: (context) => const ProfilePage(),
      notificaciones: (context) => const NotificationsPage(),

      // Rutas de reportes
      crearReporte: (context) => const ReporteAprendiz(),
    };
  }
}
