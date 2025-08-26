import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/welcome_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_step2_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/admin/inicio_admin.dart';
import '../screens/admin/aprendices_registrados/aprendiz_registrado.dart';
import '../screens/admin/aprendices_registrados/vista_aprendiz.dart';

class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String registerStep2 = '/register-step2';
  static const String home = '/home';
  static const String adminDashboard = '/admin-dashboard';
  static const String aprendicesRegistrados = '/aprendices-registrados';
  static const String vistaAprendiz = '/vista-aprendiz';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      welcome: (context) => const WelcomeScreen(),
      login: (context) => const LoginScreen(),
      registerStep2: (context) => const RegisterStep2Screen(),
      home: (context) => const HomeScreen(),
      adminDashboard: (context) => AdminDashboard(),
      aprendicesRegistrados: (context) => const AprendicesRegistrados(),
      vistaAprendiz: (context) {
        final args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return StudentProfileScreen(apprenticeData: args);
      },
    };
  }
}
