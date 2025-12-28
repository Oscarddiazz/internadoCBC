import 'package:flutter/material.dart';
import 'detalle_reporte_page.dart';

class ReportePage extends StatefulWidget {
  const ReportePage({super.key});

  @override
  State<ReportePage> createState() => _ReportePageState();
}

class _ReportePageState extends State<ReportePage> {
  List<String> reportOptions = [
    "Tarea no Terminada",
    "Celular en Horario de sueño",
    "Falta de Respeto a Delegado",
    "Riña con otro Aprendiz",
    "No presente en Dormitorio",
  ];

  String filtro = "pedido"; // pedido (default) o nombre

  void _aplicarFiltro(String nuevoFiltro) {
    setState(() {
      filtro = nuevoFiltro;
      if (filtro == "nombre") {
        reportOptions.sort((a, b) => a.compareTo(b));
      } else {
        reportOptions = [
          "Tarea no Terminada",
          "Celular en Horario de sueño",
          "Falta de Respeto a Delegado",
          "Riña con otro Aprendiz",
          "No presente en Dormitorio",
        ];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FBE4),
      appBar: AppBar(
        title: const Text("Reportes"),
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
            // 🔹 Encabezado de la sección
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Reportes de Aprendices",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text(
                  filtro == "pedido" ? "Orden: pedido" : "Orden: nombre",
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 🔹 Contenedor de reportes
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.all(16),
                child: ListView.separated(
                  itemCount: reportOptions.length,
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final report = reportOptions[index];
                    return GestureDetector(
                      onTap: () {
                        // 🔹 Aquí redirigimos al detalle del reporte
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => DetalleReportePage(
                                  titulo: report,
                                  fecha: "22/03/2023",
                                  descripcion:
                                      "Este es el detalle del reporte: $report.\n\nEl aprendiz incumplió una norma.",
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.report,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  report,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
