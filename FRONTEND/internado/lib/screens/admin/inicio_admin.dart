import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6FBE4), // Light cream background
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
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
                      SizedBox(height: 8),
                      Text(
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
                    children: [
                      Icon(Icons.search, size: 24),
                      SizedBox(width: 16),
                      Icon(Icons.notifications_outlined, size: 24),
                    ],
                  ),
                ],
              ),

              // Circular buttons section
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      // Primera fila: Aprendices y Permisos
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Aprendices Registrados - Amarillo
                          CircularButton(
                            color: Color(0xFFFFE196),
                            text: 'Aprendices\nRegistrados',
                            size: 140,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/aprendices-registrados',
                              );
                            },
                          ),
                          // Permisos - Verde
                          CircularButton(
                            color: Color(0xFF69B840),
                            text: 'Permisos',
                            size: 140,
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      // Segunda fila: Documentos y Reportes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Documentos - Marrón rojizo
                          CircularButton(
                            color: Color(0xFFCC7766),
                            text: 'Documentos',
                            size: 140,
                          ),
                          // Reportes - Azul grisáceo
                          CircularButton(
                            color: Color(0xFF879D9A),
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
        backgroundColor: Color(0xFFF6FBE4),
        elevation: 0,
        items: [
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

  CircularButton({
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
            style: TextStyle(
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
