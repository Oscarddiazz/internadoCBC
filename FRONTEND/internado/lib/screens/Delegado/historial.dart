import 'package:flutter/material.dart';

class HistorialPage extends StatelessWidget {
  const HistorialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contacts = [
      {"name": "Wilson Duarte Vaca", "status": "Ahora mismo"},
      {"name": "Jesús David Aguilar Lopez", "status": "Hace 15 minutos"},
      {"name": "Diego Andrés Montero", "status": "Ayer"},
      {"name": "Dilan Omar Morales Reyes", "status": "Hace 6 horas"},
      {"name": "Emily Norena Mercado", "status": "Ahora mismo"},
      {"name": "Javier Enrique Pinzón", "status": "Hace 30 minutos"},
      {"name": "Juan Camilo Goyeneche", "status": "Ahora mismo"},
      {"name": "Abelardo Vásquez Herrera", "status": "Ahora mismo"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6FBE4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 32),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Historial',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),
                // Contact Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact["name"]!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        contact["status"]!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
