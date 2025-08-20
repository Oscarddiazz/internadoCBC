import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/welcome_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_step2_screen.dart';
import '../screens/home/home_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String registerStep2 = '/register-step2';
  static const String home = '/home';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      welcome: (context) => const WelcomeScreen(),
      login: (context) => const LoginScreen(),
      registerStep2: (context) => const RegisterStep2Screen(),
      home: (context) => const HomeScreen(),
    };
  }
}
