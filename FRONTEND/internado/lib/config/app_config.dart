class AppConfig {
  // URLs del backend
  // Para emulador Android usar 10.0.2.2
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  // Para localhost (solo funciona en web o iOS simulator)
  // static const String baseUrl = 'http://localhost:3000/api';

  // Para dispositivos físicos, cambiar a la IP de tu computadora
  // static const String baseUrl = 'http://192.168.1.XXX:3000/api';

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
}
