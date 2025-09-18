import 'dart:io';
import 'package:flutter/foundation.dart';
import 'network_config.dart';

class AppConfig {
  // URLs del backend - Configuración flexible usando NetworkConfig
  static String get baseUrl => NetworkConfig.baseUrl;

  // Configuración de la aplicación
  static const String appName = 'BioHub - Sistema de Internado';
  static const String appVersion = '1.0.0';

  // Colores de la aplicación
  static const int primaryColor = 0xFF2E7D32; // Verde SENA
  static const int secondaryColor = 0xFF4CAF50;
  static const int backgroundColor = 0xFFF5F5F5;

  // Tiempos de timeout
  static const int connectionTimeout = 30000; // 30 segundos
  static const int receiveTimeout = 30000; // 30 segundos

  // Configuración de almacenamiento
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';

  // Mensajes de error comunes
  static const String networkError =
      'Error de conexión. Verifica tu conexión a internet.';
  static const String serverError = 'Error del servidor. Intenta más tarde.';
  static const String authError =
      'Error de autenticación. Inicia sesión nuevamente.';


  // Método para obtener información de la plataforma actual
  static String get platformInfo {
    if (kIsWeb) {
      return 'Web';
    } else if (Platform.isAndroid) {
      return 'Android';
    } else if (Platform.isIOS) {
      return 'iOS';
    } else {
      return 'Unknown';
    }
  }

  // Método para debug - mostrar la URL que se está usando (solo en debug)
  static void printCurrentConfig() {
    if (kDebugMode) {
      debugPrint('🌐 Plataforma: $platformInfo');
      debugPrint('🔗 URL Base: $baseUrl');
      debugPrint('📱 App: $appName v$appVersion');
      NetworkConfig.printConfig();
    }
  }
}
