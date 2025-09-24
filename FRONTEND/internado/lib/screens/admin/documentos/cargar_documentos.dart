import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class CargarDocumentos extends StatefulWidget {
  const CargarDocumentos({super.key});

  @override
  State<CargarDocumentos> createState() => _CargarDocumentosState();
}

class _CargarDocumentosState extends State<CargarDocumentos> {
  String? _tipoSeleccionado;
  String? _archivoSeleccionado;
  final TextEditingController _nombreArchivoController =
      TextEditingController();

  final List<String> tiposArchivos = ["PDF", "Word", "Imagen", "Excel"];

  // Variables para el BottomNavigationBar
  int _selectedIndex = 0; // Variable para controlar el índice seleccionado

  Future<void> _seleccionarArchivo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _archivoSeleccionado = result.files.single.name;
      });
    }
  }

  void _subirDocumento() {
    if (_tipoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor seleccione un tipo de archivo"),
        ),
      );
      return;
    }

    if (_nombreArchivoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor ingrese un nombre para el archivo"),
        ),
      );
      return;
    }

    if (_archivoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor adjunte un archivo")),
      );
      return;
    }

    // Mostrar pantalla emergente
    showDialog(
      context: context,
      barrierDismissible: false, // no se cierra tocando afuera
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text("✅ Documento subido"),
          content: const Text("El documento ha sido cargado exitosamente."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // cerrar el diálogo
                Navigator.of(context).pop(); // volver al inicio
              },
              child: const Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cargar Documentos"),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Seleccionar tipo de archivo
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Seleccione el tipo de archivo",
                      border: OutlineInputBorder(),
                    ),
                    value: _tipoSeleccionado,
                    items:
                        tiposArchivos
                            .map(
                              (tipo) => DropdownMenuItem(
                                value: tipo,
                                child: Text(tipo),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        _tipoSeleccionado = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // Campo para nombre del archivo
                  TextField(
                    controller: _nombreArchivoController,
                    decoration: const InputDecoration(
                      labelText: "Nombre del archivo",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Botón para adjuntar archivo
                  ElevatedButton.icon(
                    icon: const Icon(Icons.attach_file, color: Colors.black),
                    label: Text(
                      _archivoSeleccionado ?? "Adjuntar archivo",
                      style: const TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.black),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 15.0,
                      ),
                    ),
                    onPressed: _seleccionarArchivo,
                  ),
                  const SizedBox(height: 30),

                  // Botón para subir documento
                  ElevatedButton.icon(
                    icon: const Icon(Icons.cloud_upload, color: Colors.black),
                    label: const Text(
                      "Subir Documento",
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 15.0,
                      ),
                    ),
                    onPressed: _subirDocumento,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // Aquí está el BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF6FBE4),
        elevation: 0,
        currentIndex: _selectedIndex,
        onTap: (index) {
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
}
