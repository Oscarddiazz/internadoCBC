import '../models/usuario.dart';
import '../models/tarea.dart';
import '../models/permiso.dart';
import 'api_service.dart';

class DataService {
  // ========== USUARIOS ==========
  
  /// Obtener todos los usuarios con filtros opcionales
  static Future<List<Usuario>> getUsuarios({
    String? rol,
    int? ficha,
  }) async {
    try {
      final result = await ApiService.getUsuarios(rol: rol, ficha: ficha);
      if (result['success']) {
        final List<dynamic> usersData = result['data'];
        return usersData.map((userData) => Usuario.fromJson(userData)).toList();
      }
      throw Exception(result['message'] ?? 'Error al obtener usuarios');
    } catch (e) {
      throw Exception('Error obteniendo usuarios: $e');
    }
  }

  /// Obtener usuario por ID
  static Future<Usuario> getUsuario(int userId) async {
    try {
      final result = await ApiService.getUsuario(userId);
      if (result['success']) {
        return Usuario.fromJson(result['data']);
      }
      throw Exception(result['message'] ?? 'Error al obtener usuario');
    } catch (e) {
      throw Exception('Error obteniendo usuario: $e');
    }
  }

  /// Obtener aprendices
  static Future<List<Usuario>> getAprendices() async {
    try {
      final result = await ApiService.getAprendices();
      if (result['success']) {
        final List<dynamic> usersData = result['data'];
        return usersData.map((userData) => Usuario.fromJson(userData)).toList();
      }
      throw Exception(result['message'] ?? 'Error al obtener aprendices');
    } catch (e) {
      throw Exception('Error obteniendo aprendices: $e');
    }
  }

  /// Obtener delegados
  static Future<List<Usuario>> getDelegados() async {
    try {
      final result = await ApiService.getDelegados();
      if (result['success']) {
        final List<dynamic> usersData = result['data'];
        return usersData.map((userData) => Usuario.fromJson(userData)).toList();
      }
      throw Exception(result['message'] ?? 'Error al obtener delegados');
    } catch (e) {
      throw Exception('Error obteniendo delegados: $e');
    }
  }

  /// Crear usuario
  static Future<Usuario> createUser(Map<String, dynamic> userData) async {
    try {
      final result = await ApiService.createUser(userData);
      if (result['success']) {
        return Usuario.fromJson(result['data']);
      }
      throw Exception(result['message'] ?? 'Error al crear usuario');
    } catch (e) {
      throw Exception('Error creando usuario: $e');
    }
  }

  /// Actualizar usuario
  static Future<Usuario> updateUser({
    required int userId,
    Map<String, dynamic>? userData,
  }) async {
    try {
      final result = await ApiService.updateUser(userId: userId, userData: userData);
      if (result['success']) {
        return Usuario.fromJson(result['data']);
      }
      throw Exception(result['message'] ?? 'Error al actualizar usuario');
    } catch (e) {
      throw Exception('Error actualizando usuario: $e');
    }
  }

  /// Cambiar rol de usuario (solo administradores)
  static Future<Usuario> changeUserRole({
    required int userId,
    required String newRole,
  }) async {
    try {
      final result = await ApiService.changeUserRole(
        userId: userId,
        newRole: newRole,
      );
      if (result['success']) {
        return Usuario.fromJson(result['data']);
      }
      throw Exception(result['message'] ?? 'Error al cambiar rol');
    } catch (e) {
      throw Exception('Error cambiando rol: $e');
    }
  }

  /// Eliminar usuario
  static Future<bool> deleteUser(int userId) async {
    try {
      final result = await ApiService.deleteUser(userId);
      return result['success'];
    } catch (e) {
      throw Exception('Error eliminando usuario: $e');
    }
  }

  // ========== TAREAS ==========

  /// Obtener todas las tareas con filtros opcionales
  static Future<List<Tarea>> getTareas({
    String? estado,
    int? aprendizId,
  }) async {
    try {
      final result = await ApiService.getTareas(estado: estado, aprendizId: aprendizId);
      if (result['success']) {
        final List<dynamic> tasksData = result['data'];
        return tasksData.map((taskData) => Tarea.fromJson(taskData)).toList();
      }
      throw Exception(result['message'] ?? 'Error al obtener tareas');
    } catch (e) {
      throw Exception('Error obteniendo tareas: $e');
    }
  }

  /// Obtener tarea por ID
  static Future<Tarea> getTarea(int tareaId) async {
    try {
      final result = await ApiService.getTarea(tareaId);
      if (result['success']) {
        return Tarea.fromJson(result['data']);
      }
      throw Exception(result['message'] ?? 'Error al obtener tarea');
    } catch (e) {
      throw Exception('Error obteniendo tarea: $e');
    }
  }

  /// Obtener tareas por aprendiz
  static Future<List<Tarea>> getTareasByAprendiz(int aprendizId) async {
    try {
      final result = await ApiService.getTareasByAprendiz(aprendizId);
      if (result['success']) {
        final List<dynamic> tasksData = result['data'];
        return tasksData.map((taskData) => Tarea.fromJson(taskData)).toList();
      }
      throw Exception(result['message'] ?? 'Error al obtener tareas del aprendiz');
    } catch (e) {
      throw Exception('Error obteniendo tareas del aprendiz: $e');
    }
  }

  /// Crear nueva tarea
  static Future<Tarea> createTask({
    required String descripcion,
    required String fechaEntrega,
    required int aprendizId,
    String? estado,
  }) async {
    try {
      final result = await ApiService.createTask(
        descripcion: descripcion,
        fechaEntrega: fechaEntrega,
        aprendizId: aprendizId,
        estado: estado,
      );
      if (result['success']) {
        return Tarea.fromJson(result['data']);
      }
      throw Exception(result['message'] ?? 'Error al crear tarea');
    } catch (e) {
      throw Exception('Error creando tarea: $e');
    }
  }

  /// Actualizar tarea
  static Future<Tarea> updateTask({
    required int taskId,
    String? descripcion,
    String? fechaEntrega,
    String? estado,
    String? evidencia,
    String? observaciones,
  }) async {
    try {
      final result = await ApiService.updateTask(
        taskId: taskId,
        descripcion: descripcion,
        fechaEntrega: fechaEntrega,
        estado: estado,
        evidencia: evidencia,
        observaciones: observaciones,
      );
      if (result['success']) {
        return Tarea.fromJson(result['data']);
      }
      throw Exception(result['message'] ?? 'Error al actualizar tarea');
    } catch (e) {
      throw Exception('Error actualizando tarea: $e');
    }
  }

  /// Completar tarea
  static Future<Tarea> completeTask({
    required int taskId,
    String? evidencia,
  }) async {
    try {
      final result = await ApiService.completeTask(taskId, evidencia);
      if (result['success']) {
        return Tarea.fromJson(result['data']);
      }
      throw Exception(result['message'] ?? 'Error al completar tarea');
    } catch (e) {
      throw Exception('Error completando tarea: $e');
    }
  }

  /// Eliminar tarea
  static Future<bool> deleteTask(int taskId) async {
    try {
      final result = await ApiService.deleteTask(taskId);
      return result['success'];
    } catch (e) {
      throw Exception('Error eliminando tarea: $e');
    }
  }

  // ========== PERMISOS ==========

  /// Obtener todos los permisos con filtros opcionales
  static Future<List<Permiso>> getPermisos({
    String? estado,
    int? aprendizId,
  }) async {
    try {
      final result = await ApiService.getPermisos(estado: estado, aprendizId: aprendizId);
      if (result['success']) {
        final List<dynamic> permissionsData = result['data'];
        return permissionsData.map((permData) => Permiso.fromJson(permData)).toList();
      }
      throw Exception(result['message'] ?? 'Error al obtener permisos');
    } catch (e) {
      throw Exception('Error obteniendo permisos: $e');
    }
  }

  /// Obtener permiso por ID
  static Future<Permiso> getPermiso(int permisoId) async {
    try {
      final result = await ApiService.getPermiso(permisoId);
      if (result['success']) {
        return Permiso.fromJson(result['data']);
      }
      throw Exception(result['message'] ?? 'Error al obtener permiso');
    } catch (e) {
      throw Exception('Error obteniendo permiso: $e');
    }
  }

  /// Crear permiso
  static Future<Permiso> createPermiso({
    required String motivo,
    String? evidencia,
  }) async {
    try {
      final result = await ApiService.createPermiso(motivo: motivo, evidencia: evidencia);
      if (result['success']) {
        return Permiso.fromJson(result['data']);
      }
      throw Exception(result['message'] ?? 'Error al crear permiso');
    } catch (e) {
      throw Exception('Error creando permiso: $e');
    }
  }

  /// Responder a permiso (aprobado/rechazado)
  static Future<Permiso> respondToPermiso({
    required int permisoId,
    required String respuesta,
  }) async {
    try {
      final result = await ApiService.respondToPermiso(
        permisoId: permisoId,
        respuesta: respuesta,
      );
      if (result['success']) {
        return Permiso.fromJson(result['data']);
      }
      throw Exception(result['message'] ?? 'Error al responder permiso');
    } catch (e) {
      throw Exception('Error respondiendo permiso: $e');
    }
  }

  /// Eliminar permiso
  static Future<bool> deletePermiso(int permisoId) async {
    try {
      final result = await ApiService.deletePermiso(permisoId);
      return result['success'];
    } catch (e) {
      throw Exception('Error eliminando permiso: $e');
    }
  }

  // ========== UTILIDADES ==========

  /// Verificar estado del servidor
  static Future<bool> checkServerHealth() async {
    try {
      final result = await ApiService.checkServerHealth();
      return result['success'] ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Cambiar contraseña
  static Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final result = await ApiService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return result['success'];
    } catch (e) {
      throw Exception('Error cambiando contraseña: $e');
    }
  }

  // ========== MÉTODOS DE CONVENIENCIA ==========

  /// Obtener tareas pendientes
  static Future<List<Tarea>> getTareasPendientes({int? aprendizId}) async {
    return await getTareas(estado: 'Pendiente', aprendizId: aprendizId);
  }

  /// Obtener tareas completadas
  static Future<List<Tarea>> getTareasCompletadas({int? aprendizId}) async {
    return await getTareas(estado: 'Completada', aprendizId: aprendizId);
  }

  /// Obtener permisos pendientes
  static Future<List<Permiso>> getPermisosPendientes({int? aprendizId}) async {
    return await getPermisos(estado: 'pendiente', aprendizId: aprendizId);
  }

  /// Obtener permisos aprobados
  static Future<List<Permiso>> getPermisosAprobados({int? aprendizId}) async {
    return await getPermisos(estado: 'aprobado', aprendizId: aprendizId);
  }

  /// Obtener permisos rechazados
  static Future<List<Permiso>> getPermisosRechazados({int? aprendizId}) async {
    return await getPermisos(estado: 'rechazado', aprendizId: aprendizId);
  }
}
