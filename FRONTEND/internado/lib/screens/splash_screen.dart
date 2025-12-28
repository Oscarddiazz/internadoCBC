import 'package:flutter/material.dart';
import 'dart:async';
import '../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Configurar animaciones
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _startSplashAnimation();
  }

  void _startSplashAnimation() async {
    // Reiniciar animación
    _animationController.reset();
    _animationController.forward();

    // Intentar cargar usuario desde almacenamiento
    bool userLoaded = false;
    try {
      userLoaded = await AuthService.loadUserFromStorage();
    } catch (e) {
      print('Error cargando usuario: $e');
    }

    // Esperar al menos 3 segundos para la animación
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      if (userLoaded && AuthService.isLoggedIn) {
        // Usuario ya está logueado, navegar según su rol
        if (AuthService.isAdmin) {
          Navigator.pushReplacementNamed(context, '/admin-dashboard');
        } else if (AuthService.isDelegado) {
          Navigator.pushReplacementNamed(context, '/delegado-dashboard');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        // Usuario no está logueado, ir a pantalla de bienvenida
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E8), // Verde claro
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo del SENA con animación
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Image.asset(
                      'assets/img/sena.png',
                      width: 120,
                      height: 120,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            // Texto SENA con animación
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    'SENA',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            // Indicador de carga
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
            ),
          ],
        ),
      ),
    );
  }
}
