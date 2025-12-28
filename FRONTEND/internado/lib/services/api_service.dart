import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class ApiService {
  static String get baseUrl => AppConfig.baseUrl;
  static String? _token;

  // Configurar token de autenticación
  static void setToken(String token) {
    _token = token;
  }

  // Obtener headers con autenticación
  static Map<String, String> get _headers {
    Map<String, String> headers = {'Content-Type': 'application/json'};

    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return headers;
  }

  // Autenticación
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          _token = data['data']['token'];
          return data;
        } else {
          throw Exception(data['message'] ?? 'Error de autenticación');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ??
              'Error de autenticación: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener perfil del usuario autenticado
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/profile'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Error al obtener perfil');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ??
              'Error al obtener perfil: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Usuarios
  static Future<Map<String, dynamic>> getUsuarios({
    String? rol,
    int? ficha,
  }) async {
    try {
      String url = '$baseUrl/users';
      List<String> params = [];

      if (rol != null) params.add('rol=$rol');
      if (ficha != null) params.add('ficha=$ficha');

      if (params.isNotEmpty) {
        url += '?${params.join('&')}';
      }

      final response = await http.get(Uri.parse(url), headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Error al obtener usuarios');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ??
              'Error al obtener usuarios: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<Map<String, dynamic>> getUsuario(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Error al obtener usuario');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ??
              'Error al obtener usuario: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener aprendices (filtrar por rol)
  static Future<Map<String, dynamic>> getAprendices() async {
    return await getUsuarios(rol: 'Aprendiz');
  }

  // Obtener delegados (filtrar por rol)
  static Future<Map<String, dynamic>> getDelegados() async {
    return await getUsuarios(rol: 'Delegado');
  }

  // Tareas
  static Future<Map<String, dynamic>> getTareas({
    String? estado,
    int? aprendizId,
  }) async {
    try {
      String url = '$baseUrl/tasks';
      List<String> params = [];

      if (estado != null) params.add('estado=$estado');
      if (aprendizId != null) params.add('aprendiz_id=$aprendizId');

      if (params.isNotEmpty) {
        url += '?${params.join('&')}';
      }

      final response = await http.get(Uri.parse(url), headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Error al obtener tareas');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ??
              'Error al obtener tareas: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<Map<String, dynamic>> getTarea(int tareaId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tasks/$tareaId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Error al obtener tarea');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ??
              'Error al obtener tarea: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener tareas por aprendiz
  static Future<Map<String, dynamic>> getTareasByAprendiz(
    int aprendizId,
  ) async {
    return await getTareas(aprendizId: aprendizId);
  }

  // Crear nueva tarea
  static Future<Map<String, dynamic>> createTask({
    required String descripcion,
    required String fechaEntrega,
    required int aprendizId,
    String? estado,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tasks'),
        headers: _headers,
        body: json.encode({
          'tarea_descripcion': descripcion,
          'tarea_fec_entrega': fechaEntrega,
          'tarea_aprendiz_id': aprendizId,
          'tarea_estado': estado ?? 'Pendiente',
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Error al crear tarea');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ??
              'Error al crear tarea: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Completar tarea
  static Future<Map<String, dynamic>> completeTask(
    int taskId,
    String? evidencia,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/tasks/$taskId/complete'),
        headers: _headers,
        body: json.encode({'tarea_evidencia': evidencia}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Error al completar tarea');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ??
              'Error al completar tarea: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Permisos
  static Future<Map<String, dynamic>> getPermisos({
    String? estado,
    int? aprendizId,
  }) async {
    try {
      String url = '$baseUrl/permissions';
      List<String> params = [];

      if (estado != null) params.add('estado=$estado');
      if (aprendizId != null) params.add('aprendiz_id=$aprendizId');

      if (params.isNotEmpty) {
        url += '?${params.join('&')}';
      }

      final response = await http.get(Uri.parse(url), headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Error al obtener permisos');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ??
              'Error al obtener permisos: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Crear permiso
  static Future<Map<String, dynamic>> createPermiso({
    required String motivo,
    String? evidencia,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/permissions'),
        headers: _headers,
        body: json.encode({
          'permiso_motivo': motivo,
          'permiso_evidencia': evidencia,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Error al crear permiso');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ??
              'Error al crear permiso: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Registro de usuario
  static Future<Map<String, dynamic>> register(
    Map<String, dynamic> userData,
  ) async {
    try {
      print('DEBUG: Enviando request a: $baseUrl/auth/register');
      print('DEBUG: Datos enviados: $userData');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      print('DEBUG: Status code: ${response.statusCode}');
      print('DEBUG: Response body: ${response.body}');

      final data = json.decode(response.body);

      if (response.statusCode == 201 && data['success']) {
        _token = data['data']['token'];
        return {
          'success': true,
          'message': data['message'],
          'data': data['data'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Error en el registro',
        };
      }
    } catch (e) {
      print('DEBUG: Error en API Service: $e');
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  // Actualizar tarea
  static Future<Map<String, dynamic>> updateTask({
    required int taskId,
    String? descripcion,
    String? fechaEntrega,
    String? estado,
    String? evidencia,
    String? observaciones,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (descripcion != null) body['tarea_descripcion'] = descripcion;
      if (fechaEntrega != null) body['tarea_fec_entrega'] = fechaEntrega;
      if (estado != null) body['tarea_estado'] = estado;
      if (evidencia != null) body['tarea_evidencia'] = evidencia;
      if (observaciones != null) body['tarea_observaciones'] = observaciones;

      final response = await http.put(
        Uri.parse('$baseUrl/tasks/$taskId'),
        headers: _headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Error al actualizar tarea');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ??
              'Error al actualizar tarea: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Eliminar tarea
  static Future<Map<String, dynamic>> deleteTask(int taskId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/tasks/$taskId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Error al eliminar tarea');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ??
              'Error al eliminar tarea: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener permiso por ID
  static Future<Map<String, dynamic>> getPermiso(int permisoId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/permissions/$permisoId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Error al obtener permiso');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ??
              'Error al obtener permiso: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Responder a permiso (aprobado/rechazado)
  static Future<Map<String, dynamic>> respondToPermiso({
    required int permisoId,
    required String respuesta, // 'aprobado' o 'rechazado'
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/permissions/$permisoId/respond'),
        headers: _headers,
        body: json.encode({'respuesta': respuesta}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Error al responder permiso');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ??
              'Error al responder permiso: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Eliminar permiso
  static Future<Map<String, dynamic>> deletePermiso(int permisoId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/permissions/$permisoId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Error al eliminar permiso');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ??
              'Error al eliminar permiso: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Crear usuario (solo para administradores)
  static Future<Map<String, dynamic>> createUser(
    Map<String, dynamic> userData,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: _headers,
        body: json.encode(userData),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Error al crear usuario');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ??
              'Error al crear usuario: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Actualizar usuario
  static Future<Map<String, dynamic>> updateUser({
    required int userId,
    Map<String, dynamic>? userData,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/$userId'),
        headers: _headers,
        body: json.encode(userData ?? {}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Error al actualizar usuario');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ??
              'Error al actualizar usuario: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Eliminar usuario
  static Future<Map<String, dynamic>> deleteUser(int userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/users/$userId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Error al eliminar usuario');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ??
              'Error al eliminar usuario: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Cambiar rol de usuario (solo administradores)
  static Future<Map<String, dynamic>> changeUserRole({
    required int userId,
    required String newRole,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/$userId/role'),
        headers: _headers,
        body: json.encode({'user_rol': newRole}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Error al cambiar rol');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ??
              'Error al cambiar rol: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Cambiar contraseña
  static Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/auth/change-password'),
        headers: _headers,
        body: json.encode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Error al cambiar contraseña');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ??
              'Error al cambiar contraseña: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Verificar estado del servidor
  static Future<Map<String, dynamic>> checkServerHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Servidor no disponible: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener usuario por cédula (para delegados)
  static Future<Map<String, dynamic>> getUserByCedula(String cedula) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/cedula/$cedula'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Error al obtener usuario');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ??
              'Error al obtener usuario: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener historial de aprendices (para delegados)
  static Future<Map<String, dynamic>> getAprendicesHistory() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/history/aprendices'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Error al obtener historial');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ??
              'Error al obtener historial: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener historial de un aprendiz específico
  static Future<Map<String, dynamic>> getAprendizHistory(int aprendizId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/history/aprendiz/$aprendizId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Error al obtener historial del aprendiz');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ??
              'Error al obtener historial del aprendiz: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Cerrar sesión
  static void logout() {
    _token = null;
  }

  // Método para debug - mostrar configuración actual
  static void printApiConfig() {
    print('🔧 API Service Configuration:');
    print('   Base URL: $baseUrl');
    print('   Token: ${_token != null ? "Presente" : "No presente"}');
    AppConfig.printCurrentConfig();
  }
}
