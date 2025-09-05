import 'package:flutter/material.dart';
import 'documentos/cargar_documentos.dart'; // 👈 importa tu archivo
import 'documentos/vista_documentos.dart'; // 👈 importa la nueva pantalla

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  void _mostrarOpcionesDocumentos(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Documentos"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.upload_file, color: Colors.blue),
                  title: const Text("Cargar documento"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CargarDocumentos(),
                      ),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.visibility, color: Colors.green),
                  title: const Text("Visualizar documento"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VisualizarDocumentos(),
                      ),
                    );
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cerrar"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/configuracion');
            },
          ),
        ],
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
                      const Text(
                        'Buenos días, Admin',
                        style: TextStyle(
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
                            text: 'Aprendices\nRegistrados',
                            size: 140,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/aprendices-registrados',
                              );
                            },
                          ),
                          CircularButton(
                            color: const Color(0xFF69B840),
                            text: 'Solicitudes\nPermiso',
                            size: 140,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/solicitudes-permiso',
                              );
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
                            text: 'Documentos',
                            size: 140,
                            onTap: () {
                              _mostrarOpcionesDocumentos(context);
                            },
                          ),
                          CircularButton(
                            color: const Color(0xFF879D9A),
                            text: 'Reportes',
                            size: 140,
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
          // Navegación según el índice seleccionado
          switch (index) {
            case 0: // Home
              Navigator.pushReplacementNamed(context, '/admin-dashboard');
              break;
            case 1: // Perfil (ya estamos aquí)
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

// Variables para el BottomNavigationBar
int _selectedIndex = 0; // Variable para controlar el índice seleccionado

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
