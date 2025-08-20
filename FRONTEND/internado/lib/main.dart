import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart'; // 👈 Importar LoginScreen

void main() {
  runApp(const BioHubApp());
}

class BioHubApp extends StatelessWidget {
  const BioHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BioHub',
      theme: ThemeData(primaryColor: const Color(0xFF39A900)),
      home: const SplashScreen(),
    );
  }
}

/// Pantalla de Carga (Splash)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BioHubWelcome()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo del SENA
            SizedBox(
              width: 200,
              height: 200,
              child: Image.asset("assets/images/logosena.png"),
            ),
            const SizedBox(height: 30),
            // Indicador de carga
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF39A900)),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pantalla Principal
class BioHubWelcome extends StatelessWidget {
  const BioHubWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FBE4),
      body: Column(
        children: [
          // Barra superior simulando estado
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween),
          ),

          // Contenido principal
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  // Texto de bienvenida
                  const Text(
                    "¡Bienvenido a\nBioHub!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF39A900),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Nos alegra tenerte aquí",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF39A900),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Imagen o ilustración
                  SizedBox(
                    width: 200,
                    height: 140,
                    child: Image.asset("assets/images/logosena.png"),
                  ),
                  const SizedBox(height: 30),
                  // Quote
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '"Automatización y Eficiencia: hacia un internado moderno y organizado para todos".',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Botones
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        _actionButton(
                          text: "Comencemos",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Botón reutilizable
  static Widget _actionButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 55),
        side: const BorderSide(color: Colors.black, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.transparent,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF39A900),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
