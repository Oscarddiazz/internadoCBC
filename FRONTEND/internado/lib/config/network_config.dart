import 'dart:io';
import 'package:flutter/foundation.dart';

class NetworkConfig {
  // IP del servidor de producción - Configurada para producción real
  static String _productionIP = '192.168.1.2'; // IP del servidor en producción
  static int _port = 3000;

  // Modo de producción - ACTIVADO para notificaciones en tiempo real
  static bool _isProduction = false;

  // Obtener la URL base según la plataforma
  static String get baseUrl {
    if (_isProduction) {
      // Modo producción - usar IP del servidor
      return 'http://$_productionIP:$_port/api';
    } else {
      // Modo desarrollo
      if (kIsWeb) {
        return 'http://localhost:$_port/api';
      } else if (Platform.isAndroid) {
        return 'http://10.0.2.2:$_port/api';
      } else if (Platform.isIOS) {
        return 'http://localhost:$_port/api';
      } else {
        return 'http://$_productionIP:$_port/api';
      }
    }
  }

  // Configurar IP de producción
  static void setProductionIP(String ip) {
    _productionIP = ip;
    if (kDebugMode) {
      debugPrint('🔧 IP de producción cambiada a: $ip');
    }
  }

  // Configurar puerto
  static void setPort(int port) {
    _port = port;
    if (kDebugMode) {
      debugPrint('🔧 Puerto cambiado a: $port');
    }
  }

  // Activar/desactivar modo producción
  static void setProductionMode(bool isProduction) {
    _isProduction = isProduction;
    if (kDebugMode) {
      debugPrint(
        '🔧 Modo producción: ${isProduction ? "ACTIVADO" : "DESACTIVADO"}',
      );
    }
  }

  // Obtener IP de producción actual
  static String get productionIP => _productionIP;

  // Obtener puerto actual
  static int get port => _port;

  // Mostrar configuración actual (solo en debug)
  static void printConfig() {
    if (kDebugMode) {
      debugPrint('🌐 ===== CONFIGURACIÓN DE RED =====');
      debugPrint('📱 Plataforma: ${_getPlatformName()}');
      debugPrint('🔗 URL Base: $baseUrl');
      debugPrint('🏭 Modo Producción: $_isProduction');
      debugPrint('🌍 IP Producción: $_productionIP');
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
