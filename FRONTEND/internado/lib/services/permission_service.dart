import 'package:flutter/material.dart';
import 'api_service.dart';

class PermissionService {
  // Obtener todos los permisos
  static Future<Map<String, dynamic>> getPermisos({
    String? estado,
    int? aprendizId,
  }) async {
    try {
      return await ApiService.getPermisos(estado: estado, aprendizId: aprendizId);
    } catch (e) {
      throw Exception('Error obteniendo permisos: $e');
    }
  }

  // Crear nuevo permiso
  static Future<Map<String, dynamic>> createPermiso({
    required String motivo,
    String? evidencia,
  }) async {
    try {
      return await ApiService.createPermiso(
        motivo: motivo,
        evidencia: evidencia,
      );
    } catch (e) {
      throw Exception('Error creando permiso: $e');
    }
  }

  // Mostrar mensaje de error
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Mostrar mensaje de éxito
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
}
