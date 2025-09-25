import 'package:flutter/material.dart';
import 'detalle_tarea.dart'; // 👈 Importa la otra página

class TareasDirigidasPage extends StatefulWidget {
  const TareasDirigidasPage({super.key});

  @override
  State<TareasDirigidasPage> createState() => _TareasDirigidasPageState();
}

class _TareasDirigidasPageState extends State<TareasDirigidasPage> {
  List<Map<String, dynamic>> tasks = [
    {
      "id": 1,
      "name": "Barrer Ambiente A",
      "color": const Color(0xFF22FB00),
      "hora": "08:30 AM",
    },
    {
      "id": 2,
      "name": "Limpieza de Habitación",
      "color": const Color(0xFFFB0000),
      "hora": "09:15 AM",
    },
    {
      "id": 3,
      "name": "Limpiar mesas Casino",
      "color": const Color(0xFFFADD00),
      "hora": "12:00 PM",
    },
    {
      "id": 4,
      "name": "XXXXXXXXXXXX",
      "color": const Color(0xFF22FB00),
      "hora": "01:45 PM",
    },
    {
      "id": 5,
      "name": "XXXXXXXXXXXX",
      "color": const Color(0xFF22FB00),
      "hora": "02:10 PM",
    },
    {
      "id": 6,
      "name": "XXXXXXXXXXXX",
      "color": const Color(0xFF22FB00),
      "hora": "03:20 PM",
    },
    {
      "id": 7,
      "name": "XXXXXXXXXXXX",
      "color": const Color(0xFF22FB00),
      "hora": "04:05 PM",
    },
  ];

  String filtro = "pedido"; // pedido (default) o nombre

  // 🔹 Datos de ejemplo del aprendiz
  final Map<String, String> aprendiz = {
    "nombre": "Juan",
    "apellido": "Pérez",
    "documento": "CC 123456789",
    "correo": "juan.perez@example.com",
    "telefono": "+57 300 123 4567",
  };

  void _aplicarFiltro(String nuevoFiltro) {
    setState(() {
      filtro = nuevoFiltro;

      if (filtro == "nombre") {
        tasks.sort((a, b) => a["name"].compareTo(b["name"]));
      } else {
        tasks.sort((a, b) => a["id"].compareTo(b["id"])); // orden original
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FBE4),
      appBar: AppBar(
        title: const Text("Tareas Dirigidas"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onSelected: _aplicarFiltro,
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: "pedido",
                    child: Text("Ordenar por pedido (viejo → nuevo)"),
                  ),
                  const PopupMenuItem(
                    value: "nombre",
                    child: Text("Ordenar por nombre (A → Z)"),
                  ),
                ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔹 Formato de aprendiz registrado
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${aprendiz['nombre']} ${aprendiz['apellido']}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text("📄 Documento: ${aprendiz['documento']}"),
                  Text("📧 Correo: ${aprendiz['correo']}"),
                  Text("📞 Teléfono: ${aprendiz['telefono']}"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Contenedor de tareas
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Encabezado de tareas
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Tareas",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          filtro == "pedido"
                              ? "Orden: pedido"
                              : "Orden: nombre",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Lista de tareas
                    Expanded(
                      child: ListView.separated(
                        itemCount: tasks.length,
                        separatorBuilder:
                            (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return GestureDetector(
                            onTap: () {
                              // 👉 Abrir página de detalles
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => DetalleTareaPage(
                                        nombre: task["name"],
                                        hora: task["hora"],
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: task["color"],
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        task["name"],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    task["hora"],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
