//Pantalla donde se visualizan los perfiles de los aprendices
import 'package:flutter/material.dart';

class StudentProfileScreen extends StatefulWidget {
  final Map<String, dynamic> apprenticeData;

  const StudentProfileScreen({super.key, required this.apprenticeData});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  int _selectedIndex = 1; // Índice del perfil seleccionado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FBE4),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.chevron_left,
                      size: 32,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Perfil Aprendiz',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Profile Card
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Profile Photo Placeholder
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Student Information
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRow(
                                  '• CC: ${widget.apprenticeData['user_num_ident']}',
                                ),
                                _buildInfoRow(
                                  '• ${widget.apprenticeData['user_name']} ${widget.apprenticeData['user_ape']}',
                                ),
                                _buildInfoRow(
                                  '• ${widget.apprenticeData['user_email']}',
                                ),
                                _buildInfoRow(
                                  '• Analisis y Desarrollo de Software',
                                ),
                                _buildInfoRow(
                                  '• Ficha: ${widget.apprenticeData['ficha_Apr']}',
                                ),
                                _buildInfoRow('• Edad: 18'),
                                _buildInfoRow('• Dormitorio: 7'),
                                _buildInfoRow(
                                  '• Inicio de Formacion: ${widget.apprenticeData['fec_ini_form_Apr']}',
                                ),
                                _buildInfoRow(
                                  '• Fin de Formacion: ${widget.apprenticeData['fec_fin_form_Apr']}',
                                ),
                                _buildInfoRow(
                                  '• Etapa Formativa: ${widget.apprenticeData['etp_form_Apr']}',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF6FBE4),
        elevation: 0,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          // Navegación según el índice seleccionado
          switch (index) {
            case 0: // Home
              Navigator.pushReplacementNamed(context, '/admin-dashboard');
              break;
            case 1: // Perfil (ya estamos aquí)
              break;
            case 2: // Configuración
              Navigator.pushNamed(context, '/configuracion-admin');
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

  Widget _buildInfoRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    );
  }
}
