import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario.dart';
import 'api_service.dart';

class AuthService {
  static Usuario? _currentUser;
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // Login real conectado al backend
  static Future<bool> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      final result = await ApiService.login(email, password);

      if (result['success']) {
        // Guardar token en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, result['data']['token']);

        // Guardar datos del usuario
        final userData = result['data']['user'];
        await prefs.setString(_userKey, userData.toString());

        // Crear objeto Usuario
        _currentUser = Usuario(
          userId: userData['user_id'],
          userNumIdent: userData['user_num_ident'] ?? '',
          userName: userData['user_name'] ?? '',
          userApe: userData['user_ape'] ?? '',
          userEmail: userData['user_email'] ?? '',
          userPass: '', // No guardar contraseña en memoria
          userRol: _mapRolFromString(userData['user_rol']),
          userDiscap: _mapDiscapacidadFromString(userData['user_discap']),
          etpFormApr: _mapEtapaFromString(userData['etp_form_Apr']),
          userGen: _mapGeneroFromString(userData['user_gen']),
          userEtn: _mapEtniaFromString(userData['user_etn']),
          userImg: userData['user_img'] ?? 'default.png',
          fecIniFormApr:
              userData['fec_ini_form_Apr'] != null
                  ? DateTime.parse(userData['fec_ini_form_Apr'])
                  : DateTime.now(),
          fecFinFormApr:
              userData['fec_fin_form_Apr'] != null
                  ? DateTime.parse(userData['fec_fin_form_Apr'])
                  : DateTime.now().add(Duration(days: 365)),
          fichaApr: userData['ficha_Apr'] ?? 0,
        );

        // Navegar según el rol
        if (_currentUser!.userRol == RolType.administrador) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/admin-dashboard',
            (route) => false,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }

        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Error en el login'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error de conexión: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  // Cargar usuario desde SharedPreferences
  static Future<bool> loadUserFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      final userDataString = prefs.getString(_userKey);

      if (token != null && userDataString != null) {
        // Configurar token en ApiService
        ApiService.setToken(token);

        // Obtener perfil actualizado del servidor
        final profileResult = await ApiService.getProfile();
        if (profileResult['success']) {
          final userData = profileResult['data'];
          _currentUser = Usuario(
            userId: userData['user_id'],
            userNumIdent: userData['user_num_ident'] ?? '',
            userName: userData['user_name'] ?? '',
            userApe: userData['user_ape'] ?? '',
            userEmail: userData['user_email'] ?? '',
            userPass: '',
            userRol: _mapRolFromString(userData['user_rol']),
            userDiscap: _mapDiscapacidadFromString(userData['user_discap']),
            etpFormApr: _mapEtapaFromString(userData['etp_form_Apr']),
            userGen: _mapGeneroFromString(userData['user_gen']),
            userEtn: _mapEtniaFromString(userData['user_etn']),
            userImg: userData['user_img'] ?? 'default.png',
            fecIniFormApr:
                userData['fec_ini_form_Apr'] != null
                    ? DateTime.parse(userData['fec_ini_form_Apr'])
                    : DateTime.now(),
            fecFinFormApr:
                userData['fec_fin_form_Apr'] != null
                    ? DateTime.parse(userData['fec_fin_form_Apr'])
                    : DateTime.now().add(Duration(days: 365)),
            fichaApr: userData['ficha_Apr'] ?? 0,
          );
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error cargando usuario: $e');
      return false;
    }
  }

  // Registro de usuario
  static Future<bool> register(
    Map<String, dynamic> userData,
    BuildContext context,
  ) async {
    try {
      print('DEBUG: Iniciando registro con datos: $userData');
      final result = await ApiService.register(userData);
      print('DEBUG: Respuesta del API: $result');

      if (result['success']) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, result['data']['token']);
        final userDataResponse = result['data']['user'];
        await prefs.setString(_userKey, userDataResponse.toString());

        _currentUser = Usuario(
          userId: userDataResponse['user_id'],
          userNumIdent: userDataResponse['user_num_ident'] ?? '',
          userName: userDataResponse['user_name'] ?? '',
          userApe: userDataResponse['user_ape'] ?? '',
          userEmail: userDataResponse['user_email'] ?? '',
          userPass: '',
          userRol: _mapRolFromString(userDataResponse['user_rol']),
          userDiscap: _mapDiscapacidadFromString(
            userDataResponse['user_discap'],
          ),
          etpFormApr: _mapEtapaFromString(userDataResponse['etp_form_Apr']),
          userGen: _mapGeneroFromString(userDataResponse['user_gen']),
          userEtn: _mapEtniaFromString(userDataResponse['user_etn']),
          userImg: userDataResponse['user_img'] ?? 'default.png',
          fecIniFormApr:
              userDataResponse['fec_ini_form_Apr'] != null
                  ? DateTime.parse(userDataResponse['fec_ini_form_Apr'])
                  : DateTime.now(),
          fecFinFormApr:
              userDataResponse['fec_fin_form_Apr'] != null
                  ? DateTime.parse(userDataResponse['fec_fin_form_Apr'])
                  : DateTime.now().add(Duration(days: 365)),
          fichaApr: userDataResponse['ficha_Apr'] ?? 0,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Registro exitoso'),
            backgroundColor: Colors.green,
          ),
        );

        if (_currentUser!.userRol == RolType.administrador) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/admin-dashboard',
            (route) => false,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Error en el registro'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    } catch (e) {
      print('DEBUG: Error en registro: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error de conexión: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  // Logout
  static Future<void> logout(BuildContext context) async {
    try {
      // Limpiar token del ApiService
      ApiService.logout();

      // Limpiar SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userKey);

      _currentUser = null;

      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      print('Error en logout: $e');
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  // Getters
  static Usuario? get currentUser => _currentUser;
  static bool get isLoggedIn => _currentUser != null;
  static bool get isAdmin => _currentUser?.userRol == RolType.administrador;
  static bool get isDelegado => _currentUser?.userRol == RolType.delegado;
  static bool get isAprendiz => _currentUser?.userRol == RolType.aprendiz;

  // Mapeo de roles desde string a enum
  static RolType _mapRolFromString(String? rol) {
    switch (rol?.toLowerCase()) {
      case 'administrador':
        return RolType.administrador;
      case 'delegado':
        return RolType.delegado;
      case 'aprendiz':
        return RolType.aprendiz;
      default:
        return RolType.aprendiz;
    }
  }

  static DiscapacidadType _mapDiscapacidadFromString(String? discap) {
    switch (discap?.toLowerCase()) {
      case 'ninguna':
        return DiscapacidadType.ninguna;
      case 'física':
      case 'fisica':
        return DiscapacidadType.fisica;
      case 'visual':
        return DiscapacidadType.visual;
      case 'auditiva':
        return DiscapacidadType.auditiva;
      default:
        return DiscapacidadType.ninguna;
    }
  }

  static EtapaType _mapEtapaFromString(String? etapa) {
    switch (etapa?.toLowerCase()) {
      case 'lectiva':
        return EtapaType.lectiva;
      case 'productiva':
        return EtapaType.productiva;
      default:
        return EtapaType.lectiva;
    }
  }

  static GeneroType _mapGeneroFromString(String? genero) {
    switch (genero?.toLowerCase()) {
      case 'masculino':
        return GeneroType.masculino;
      case 'femenino':
        return GeneroType.femenino;
      default:
        return GeneroType.masculino;
    }
  }

  static EtniaType _mapEtniaFromString(String? etnia) {
    switch (etnia?.toLowerCase()) {
      case 'no aplica':
      case 'no_aplica':
        return EtniaType.noAplica;
      case 'indígena':
      case 'indigina':
        return EtniaType.indigina;
      case 'afrocolombiano':
      case 'afrodescendiente':
        return EtniaType.afrodescendiente;
      default:
        return EtniaType.noAplica;
    }
  }
}
