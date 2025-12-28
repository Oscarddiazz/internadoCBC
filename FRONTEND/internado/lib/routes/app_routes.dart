import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/welcome_screen.dart';
import '../screens/auth/login_screen.dart';

import '../screens/auth/register_step2_screen.dart';
import '../screens/aprendiz/menu.dart';
import '../screens/admin/menu.dart' as admin_menu;
import '../screens/admin/aprendices_registrados/aprendiz_registrado.dart';
import '../screens/admin/aprendices_registrados/vista_aprendiz.dart';
import '../screens/admin/permisos/permisos_solicitados.dart';
import '../screens/admin/reportes/crear_reporte.dart';
import '../screens/aprendiz/config.dart';
import '../screens/aprendiz/perfil.dart';
import '../screens/aprendiz/notif.dart';
import '../screens/admin/config.dart' as admin_config;
import '../screens/admin/pefil.dart' as admin_perfil;
import '../screens/admin/notif.dart' as admin_notif;
import '../screens/Delegado/menu.dart' as delegado_menu;
import '../screens/Delegado/ingresa_cedula.dart';
import '../screens/Delegado/perfil_aprendiz_casino.dart';
import '../screens/Delegado/historial.dart';
import '../screens/Delegado/perfil.dart' as delegado_perfil;
import '../screens/Delegado/config.dart' as delegado_config;
import '../screens/Delegado/notif.dart' as delegado_notif;

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

  // Rutas de delegado
  static const String delegadoDashboard = '/delegado-dashboard';
  static const String casino = '/casino';
  static const String perfilAprendiz = '/perfil-aprendiz';
  static const String historial = '/historial';

  // Rutas de configuración - Aprendiz
  static const String configuracionAprendizScreen = '/configuracion-aprendiz';
  static const String perfilAprendizScreen = '/perfil-aprendiz-screen';
  static const String notificacionesAprendizScreen = '/notificaciones-aprendiz';

  // Rutas de configuración - Admin
  static const String configuracionAdmin = '/configuracion-admin';
  static const String perfilAdmin = '/perfil-admin';
  static const String notificacionesAdmin = '/notificaciones-admin';

  // Rutas de configuración - Delegado
  static const String configuracionDelegado = '/configuracion-delegado';
  static const String perfilDelegado = '/perfil-delegado';
  static const String notificacionesDelegado = '/notificaciones-delegado';

  // Rutas de reportes
  static const String crearReporte = '/crear-reporte';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      // Rutas principales
      splash: (context) => const SplashScreen(),
      welcome: (context) => const WelcomeScreen(),
      login: (context) => const LoginScreen(),
      registerStep2: (context) => const RegisterStep2Screen(),
      home: (context) => const MenuAprendiz(),

      // Rutas de administrador
      adminDashboard: (context) => admin_menu.AdminDashboard(),
      aprendicesRegistrados: (context) => const AprendicesRegistrados(),
      vistaAprendiz: (context) {
        final args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return StudentProfileScreen(apprenticeData: args);
      },
      solicitudesPermiso: (context) => const SolicitudesPermiso(),

      // Rutas de delegado
      delegadoDashboard: (context) => const delegado_menu.DelegadoDashboard(),
      casino: (context) => const CasinoNumberPad(),
      perfilAprendiz: (context) {
        final args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
        return PerfilAprendiz(
          cedula: args?['cedula'] ?? '',
          userData: args?['userData'],
        );
      },
      historial: (context) => const HistorialPage(),

      // Rutas de configuración - Aprendiz
      configuracionAprendizScreen: (context) => const ConfiguracionScreen(),
      perfilAprendizScreen: (context) => const ProfilePage(),
      notificacionesAprendizScreen: (context) => const NotificationsPage(),

      // Rutas de configuración - Admin
      configuracionAdmin:
          (context) => const admin_config.AdminConfiguracionScreen(),
      perfilAdmin: (context) => const admin_perfil.AdminProfilePage(),
      notificacionesAdmin:
          (context) => const admin_notif.AdminNotificationsPage(),

      // Rutas de configuración - Delegado
      configuracionDelegado:
          (context) => const delegado_config.DelegadoConfiguracionScreen(),
      perfilDelegado: (context) => const delegado_perfil.DelegadoProfilePage(),
      notificacionesDelegado:
          (context) => const delegado_notif.DelegadoNotificationsPage(),

      // Rutas de reportes
      crearReporte: (context) => const ReporteAprendiz(),
    };
  }
}
