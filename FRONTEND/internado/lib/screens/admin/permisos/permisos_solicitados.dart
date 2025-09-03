import 'package:flutter/material.dart';
import 'vista_permiso.dart'; // 👈 Importamos la nueva vista

class SolicitudesPermiso extends StatefulWidget {
  const SolicitudesPermiso({Key? key}) : super(key: key);

  @override
  State<SolicitudesPermiso> createState() => _SolicitudesPermisoState();
}

class _SolicitudesPermisoState extends State<SolicitudesPermiso> {
  final List<Map<String, String>> allSolicitudes = [
    {
      "nombre": "Juan Pérez",
      "motivo": "Asistencia médica",
      "fecha": "2025-09-01",
      "detalles":
          "El aprendiz solicita permiso por cita médica con especialista.",
    },
    {
      "nombre": "María López",
      "motivo": "Permiso personal",
      "fecha": "2025-09-02",
      "detalles": "Requiere ausentarse para diligencias personales.",
    },
    {
      "nombre": "Carlos Ruiz",
      "motivo": "Cita odontológica",
      "fecha": "2025-09-03",
      "detalles":
          "El aprendiz necesita permiso para asistir a cita odontológica.",
    },
    {
      "nombre": "Ana Gómez",
      "motivo": "Diligencias familiares",
      "fecha": "2025-09-04",
      "detalles":
          "Solicita permiso para asistir a un trámite familiar importante.",
    },
    {
      "nombre": "Pedro Martínez",
      "motivo": "Permiso académico",
      "fecha": "2025-09-05",
      "detalles": "Debe ausentarse para presentar un examen académico externo.",
    },
  ];

  List<Map<String, String>> filteredSolicitudes = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredSolicitudes = List.from(allSolicitudes);
  }

  void _applyFilters() {
    setState(() {
      filteredSolicitudes =
          allSolicitudes.where((sol) {
            final searchLower = searchQuery.toLowerCase();
            return sol['nombre']!.toLowerCase().contains(searchLower) ||
                sol['motivo']!.toLowerCase().contains(searchLower) ||
                sol['fecha']!.toLowerCase().contains(searchLower);
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FBE4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6FBE4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 32),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Solicitudes de Permiso',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Barra de búsqueda
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  _applyFilters();
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, motivo o fecha...',
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Lista de solicitudes
            Expanded(
              child:
                  filteredSolicitudes.isEmpty
                      ? const Center(
                        child: Text(
                          "No hay solicitudes encontradas",
                          style: TextStyle(color: Colors.black54, fontSize: 16),
                        ),
                      )
                      : ListView.builder(
                        itemCount: filteredSolicitudes.length,
                        itemBuilder: (context, index) {
                          final solicitud = filteredSolicitudes[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: ListTile(
                              leading: const Icon(
                                Icons.request_page,
                                color: Colors.black,
                              ),
                              title: Text(
                                solicitud['nombre']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                "${solicitud['motivo']} • ${solicitud['fecha']}",
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.black54,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) =>
                                            VistaPermiso(solicitud: solicitud),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
