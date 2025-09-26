import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class InicioAprendiz extends StatefulWidget {
  const InicioAprendiz({super.key});

  @override
  State<InicioAprendiz> createState() => _InicioAprendizState();
}

class _InicioAprendizState extends State<InicioAprendiz> {
  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final res = await ApiService.getProfile();
      if (res['success'] == true) {
        setState(() {
          _userProfile = res['data'];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar perfil: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio Aprendiz'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        actions: const [Icon(Icons.settings)],
      ),
      backgroundColor: const Color(0xFFF6FBE4),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Viernes 9 de Agosto del 2025',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isLoading 
                            ? 'Cargando...'
                            : 'Buenos días, ${_userProfile?['user_name'] ?? 'Aprendiz'}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: const [
                      Icon(Icons.search, size: 24),
                      SizedBox(width: 16),
                      Icon(Icons.notifications_outlined, size: 24),
                    ],
                  ),
                ],
              ),

              // Botones circulares
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircularButton(
                            color: const Color(0xFFFFE196),
                            text: 'Mis\nDocumentos',
                            size: 140,
                            onTap: () {
                              // Acción futura
                            },
                          ),
                          CircularButton(
                            color: const Color(0xFF69B840),
                            text: 'Mis\nReportes',
                            size: 140,
                            onTap: () {
                              // Acción futura
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircularButton(
                            color: const Color(0xFFCC7766),
                            text: 'Solicitudes',
                            size: 140,
                            onTap: () {
                              // Acción futura
                            },
                          ),
                          CircularButton(
                            color: const Color(0xFF879D9A),
                            text: 'Notificaciones',
                            size: 140,
                            onTap: () {
                              // Acción futura
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF6FBE4),
        elevation: 0,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          switch (index) {
            case 0: // Home
              Navigator.pushReplacementNamed(context, '/inicio-aprendiz');
              break;
            case 1: // Perfil
              Navigator.pushNamed(context, '/perfil');
              break;
            case 2: // Configuración
              Navigator.pushNamed(context, '/configuracion');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: '',
          ),
        ],
      ),
    );
  }
}


class CircularButton extends StatelessWidget {
  final Color color;
  final String text;
  final double size;
  final VoidCallback? onTap;

  const CircularButton({
    super.key,
    required this.color,
    required this.text,
    required this.size,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
