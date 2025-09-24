//Pantalla donde se ven los documentos cargados por otros admins
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class VisualizarDocumentos extends StatefulWidget {
  const VisualizarDocumentos({super.key});

  @override
  State<VisualizarDocumentos> createState() => _VisualizarDocumentosState();
}

class _VisualizarDocumentosState extends State<VisualizarDocumentos> {
  // Lista simulada de documentos
  final List<Map<String, String>> _documentos = [
    {"nombre": "Reporte Mensual", "tipo": "PDF", "ruta": "/storage/report.pdf"},
    {"nombre": "Plan de Trabajo", "tipo": "Word", "ruta": "/storage/plan.docx"},
    {
      "nombre": "Evidencia Fotográfica",
      "tipo": "Imagen",
      "ruta": "/storage/foto.png",
    },
    {"nombre": "Base de Datos", "tipo": "Excel", "ruta": "/storage/base.xlsx"},
  ];

  void _abrirDocumento(String ruta) async {
    // Usa open_file para abrir con app nativa
    final result = await OpenFile.open(ruta);
    debugPrint("Resultado al abrir archivo: ${result.message}");
  }

  // Variables para el BottomNavigationBar
  int _selectedIndex = 0; // Variable para controlar el índice seleccionado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Visualizar Documentos"),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _documentos.length,
        itemBuilder: (context, index) {
          final doc = _documentos[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(
                _getIcono(doc["tipo"]!),
                color: Colors.green,
                size: 30,
              ),
              title: Text(doc["nombre"]!),
              subtitle: Text("Tipo: ${doc["tipo"]}"),
              trailing: IconButton(
                icon: const Icon(Icons.visibility, color: Colors.black54),
                onPressed: () => _abrirDocumento(doc["ruta"]!),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF6FBE4),
        elevation: 0,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          // Navegación según el índice seleccionado
          setState(() {
            _selectedIndex = index;
          });
          // Navegación según el índice seleccionado
          switch (index) {
            case 0: // Home
              Navigator.pushReplacementNamed(context, '/admin-dashboard');
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

  // Devuelve un icono según el tipo de archivo
  IconData _getIcono(String tipo) {
    switch (tipo.toLowerCase()) {
      case "pdf":
        return Icons.picture_as_pdf;
      case "word":
        return Icons.description;
      case "imagen":
        return Icons.image;
      case "excel":
        return Icons.table_chart;
      default:
        return Icons.insert_drive_file;
    }
  }
}
