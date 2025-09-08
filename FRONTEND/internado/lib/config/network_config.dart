import 'dart:io';
import 'package:flutter/foundation.dart';

class NetworkConfig {
  // IP local configurable
  static String _localIP = '192.168.1.100';
  static int _port = 3000;

  // Obtener la URL base según la plataforma
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:$_port/api';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:$_port/api';
    } else if (Platform.isIOS) {
      return 'http://localhost:$_port/api';
    } else {
      return 'http://$_localIP:$_port/api';
    }
  }

  // Configurar IP local
  static void setLocalIP(String ip) {
    _localIP = ip;
    if (kDebugMode) {
      debugPrint('🔧 IP local cambiada a: $ip');
    }
  }

  // Configurar puerto
  static void setPort(int port) {
    _port = port;
    if (kDebugMode) {
      debugPrint('🔧 Puerto cambiado a: $port');
    }
  }

  // Obtener IP local actual
  static String get localIP => _localIP;

  // Obtener puerto actual
  static int get port => _port;

  // Mostrar configuración actual (solo en debug)
  static void printConfig() {
    if (kDebugMode) {
      debugPrint('🌐 ===== CONFIGURACIÓN DE RED =====');
      debugPrint('📱 Plataforma: ${_getPlatformName()}');
      debugPrint('🔗 URL Base: $baseUrl');
      debugPrint('🌍 IP Local: $_localIP');
      debugPrint('🔌 Puerto: $_port');
      debugPrint('================================');
    }
  }

  // Obtener nombre de la plataforma
  static String _getPlatformName() {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    return 'Desconocida';
  }
}
