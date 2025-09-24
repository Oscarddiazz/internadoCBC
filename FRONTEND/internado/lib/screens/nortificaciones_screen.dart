import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notifications = [
      {
        'id': 1,
        'title': 'Solicitud de Permiso',
        'user': 'Juan Camilo Andres Hernandez',
        'time': 'Ahora mismo',
      },
      {
        'id': 2,
        'title': 'Tarea Dirigida Completa',
        'user': 'Juan Camilo Andres Hernandez',
        'time': 'Ahora mismo',
      },
      {
        'id': 3,
        'title': 'Nuevo Aprendiz Registrado',
        'user': 'Juan Camilo Andres Hernandez',
        'time': 'Ahora mismo',
      },
      {
        'id': 4,
        'title': 'Solicitud de Permiso',
        'user': 'Juan Camilo Andres Hernandez',
        'time': 'Ahora mismo',
      },
      {
        'id': 5,
        'title': 'Solicitud de Permiso',
        'user': 'Juan Camilo Andres Hernandez',
        'time': 'Ahora mismo',
      },
      {
        'id': 6,
        'title': 'Solicitud de Permiso',
        'user': 'Juan Camilo Andres Hernandez',
        'time': 'Ahora mismo',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xfff0f4d3), // bg-[#f0f4d3]
      body: Column(
        children: [
          // Header
          Container(
            color: Colors.white, // bg-white
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ), // px-4 py-4
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.chevron_left, // ChevronLeft icon
                      size: 24, // w-6 h-6
                      color: Colors.black, // text-black
                    ),
                  ),
                  const SizedBox(width: 12), // mr-3
                  const Text(
                    'Notificaciones',
                    style: TextStyle(
                      color: Colors.black, // text-black
                      fontSize: 20, // text-xl
                      fontWeight: FontWeight.bold, // font-bold
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Notifications List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ), // px-4 py-6
              child: ListView.separated(
                itemCount: notifications.length,
                separatorBuilder:
                    (context, index) => const SizedBox(height: 24), // space-y-6
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start, // items-start
                    children: [
                      // Avatar
                      Container(
                        width: 48, // w-12
                        height: 48, // h-12
                        decoration: const BoxDecoration(
                          color: Color(0xffc4c4c4), // bg-[#c4c4c4]
                          shape: BoxShape.circle, // rounded-full
                        ),
                      ),
                      const SizedBox(width: 16), // gap-4
                      // Content
                      Expanded(
                        // flex-1 min-w-0
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification['title'],
                              style: const TextStyle(
                                color: Colors.black, // text-black
                                fontSize: 18, // text-lg
                                fontWeight: FontWeight.w600, // font-semibold
                                height: 1.2, // leading-tight
                              ),
                            ),
                            const SizedBox(height: 4), // mb-1
                            Text(
                              notification['user'],
                              style: const TextStyle(
                                color: Color(0xff374151), // text-gray-700
                                fontSize: 14, // text-sm
                              ),
                            ),
                            const SizedBox(height: 2), // mb-0.5
                            Text(
                              notification['time'],
                              style: const TextStyle(
                                color: Color(0xff374151), // text-gray-700
                                fontSize: 14, // text-sm
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
