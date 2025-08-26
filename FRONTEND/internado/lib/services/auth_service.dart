import 'package:flutter/material.dart';
import '../models/usuario.dart';

class AuthService {
  static Usuario? _currentUser;

  // Simulación de login - en producción esto se conectaría con la API
  static Future<bool> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      // Simular delay de API
      await Future.delayed(Duration(seconds: 1));

      // Simulación de validación - en producción esto vendría del backend
      if (email == 'admin@test.com' && password == 'admin123') {
        // Usuario administrador
        _currentUser = Usuario(
          userId: 1,
          userNumIdent: '123456789',
          userName: 'Administrador',
          userApe: 'Sistema',
          userEmail: email,
          userPass: password,
          userRol: RolType.administrador,
          userDiscap: DiscapacidadType.ninguna,
          etpFormApr: EtapaType.lectiva,
          userGen: GeneroType.masculino,
          userEtn: EtniaType.no_aplica,
          userImg: 'default.png',
          fecIniFormApr: DateTime.now(),
          fecFinFormApr: DateTime.now().add(Duration(days: 365)),
          fichaApr: 123456,
        );

        // Navegar al dashboard del admin
        Navigator.pushReplacementNamed(context, '/admin-dashboard');
        return true;
      } else if (email == 'user@test.com' && password == 'user123') {
        // Usuario normal
        _currentUser = Usuario(
          userId: 2,
          userNumIdent: '987654321',
          userName: 'Usuario',
          userApe: 'Normal',
          userEmail: email,
          userPass: password,
          userRol: RolType.aprendiz,
          userDiscap: DiscapacidadType.ninguna,
          etpFormApr: EtapaType.lectiva,
          userGen: GeneroType.femenino,
          userEtn: EtniaType.no_aplica,
          userImg: 'default.png',
          fecIniFormApr: DateTime.now(),
          fecFinFormApr: DateTime.now().add(Duration(days: 365)),
          fichaApr: 654321,
        );

        // Navegar a la pantalla principal
        Navigator.pushReplacementNamed(context, '/home');
        return true;
      } else {
        // Credenciales inválidas
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Credenciales inválidas'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error en el login: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  static void logout(BuildContext context) {
    _currentUser = null;
    Navigator.pushReplacementNamed(context, '/');
  }

  static Usuario? get currentUser => _currentUser;

  static bool get isLoggedIn => _currentUser != null;

  static bool get isAdmin => _currentUser?.userRol == RolType.administrador;
}
