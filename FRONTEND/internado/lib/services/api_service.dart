import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';
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
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tasks'),
        headers: _headers,
        body: json.encode({
          'tarea_descripcion': descripcion,
          'tarea_fec_entrega': fechaEntrega,
          'tarea_aprendiz_id': aprendizId,
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
