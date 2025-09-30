import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class PerfilAprendiz extends StatelessWidget {
  final String cedula;
  final Map<String, dynamic>? userData;
  
  const PerfilAprendiz({
    super.key, 
    required this.cedula,
    this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FBE4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 32, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Perfil Aprendiz',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Grid Layout
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1,
              children: [
                // Profile Photo
                _buildCard(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.person,
                        size: 120,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),

                // Name Card
                _buildCard(
                  child: Center(
                    child: Text(
                      userData != null 
                        ? '${userData!['user_name'] ?? ''}\n${userData!['user_ape'] ?? ''}'
                        : 'Cargando...',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),

                // Empty space for grid alignment
                const SizedBox(),

                // CC Card
                _buildCard(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'CC:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cedula,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Phone and Age Card
                _buildCard(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Telefono:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userData?['user_tel'] ?? 'No disponible',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Rol: Aprendiz',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Ficha and Etapa Card
                _buildCard(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Ficha: ${userData?['ficha_Apr'] ?? 'No disponible'}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Etapa: ${userData?['etp_form_Apr'] ?? 'No disponible'}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Email Card
                _buildCard(
                  child: Center(
                    child: Text(
                      userData?['user_email'] ?? 'No disponible',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                  ),
                ),

                // Program Card
                _buildCard(
                  child: const Center(
                    child: Text(
                      'Analisis y\nDesarrollo de\nSoftware',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Training Dates Card (Full Width)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Text(
                    'Inicio de Formacion: ${userData?['fec_ini_form_Apr'] ?? 'No disponible'}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Fin de Formacion: ${userData?['fec_fin_form_Apr'] ?? 'No disponible'}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black, width: 2)),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          currentIndex: 1, // Perfil seleccionado
          onTap: (index) {
            switch (index) {
              case 0:
                // Navegar a inicio_delegado y limpiar el stack de navegación
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.delegadoDashboard,
                  (route) => false,
                );
                break;
              case 1:
                Navigator.pushNamed(context, AppRoutes.perfil);
                break;
              case 2:
                Navigator.pushNamed(context, AppRoutes.configuracion);
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 32),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 32),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings, size: 32),
              label: '',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: child,
    );
  }
}
