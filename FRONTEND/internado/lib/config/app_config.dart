import 'dart:io';
import 'package:flutter/foundation.dart';

class AppConfig {
  // URLs del backend - Configuración simple y directa
  static String get baseUrl {
    // Para web, usar localhost
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    }

    // Para Android emulator, usar 10.0.2.2
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000/api';
    }

    // Para iOS simulator, usar localhost
    if (Platform.isIOS) {
      return 'http://localhost:3000/api';
    }

    // Para dispositivos físicos, usar la IP de tu computadora
    // CAMBIA ESTA IP POR LA IP DE TU COMPUTADORA
    return 'http://192.168.1.100:3000/api';
  }

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

  // Credenciales de prueba
  static const Map<String, String> testCredentials = {
    'admin': 'pedro.suarez@sena.edu.co',
    'admin_password': 'admin123',
    'delegado': 'juan.martinez@sena.edu.co',
    'delegado_password': 'delegado1',
    'aprendiz': 'carlos.gomez@sena.edu.co',
    'aprendiz_password': 'aprendiz1',
  };

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

  // Método para debug - mostrar la URL que se está usando
  static void printCurrentConfig() {
    print('🌐 Plataforma: $platformInfo');
    print('🔗 URL Base: $baseUrl');
    print('📱 App: $appName v$appVersion');
  }
}
