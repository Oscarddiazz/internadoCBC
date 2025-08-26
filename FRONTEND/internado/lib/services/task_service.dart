import 'package:flutter/material.dart';
import 'api_service.dart';

class TaskService {
  // Obtener todas las tareas
  static Future<Map<String, dynamic>> getTareas({
    String? estado,
    int? aprendizId,
  }) async {
    try {
      return await ApiService.getTareas(estado: estado, aprendizId: aprendizId);
    } catch (e) {
      throw Exception('Error obteniendo tareas: $e');
    }
  }

  // Obtener tarea por ID
  static Future<Map<String, dynamic>> getTarea(int tareaId) async {
    try {
      return await ApiService.getTarea(tareaId);
    } catch (e) {
      throw Exception('Error obteniendo tarea: $e');
    }
  }

  // Crear nueva tarea
  static Future<Map<String, dynamic>> createTarea({
    required String descripcion,
    required String fechaEntrega,
    required int aprendizId,
  }) async {
    try {
      return await ApiService.createTask(
        descripcion: descripcion,
        fechaEntrega: fechaEntrega,
        aprendizId: aprendizId,
      );
    } catch (e) {
      throw Exception('Error creando tarea: $e');
    }
  }

  // Completar tarea
  static Future<Map<String, dynamic>> completarTarea(
    int taskId,
    String? evidencia,
  ) async {
    try {
      return await ApiService.completeTask(taskId, evidencia);
    } catch (e) {
      throw Exception('Error completando tarea: $e');
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
