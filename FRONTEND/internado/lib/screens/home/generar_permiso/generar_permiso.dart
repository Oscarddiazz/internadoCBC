import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class GenerarPermisoPage extends StatefulWidget {
  const GenerarPermisoPage({super.key});

  @override
  State<GenerarPermisoPage> createState() => _GenerarPermisoPageState();
}

class _GenerarPermisoPageState extends State<GenerarPermisoPage> {
  final TextEditingController motivoController = TextEditingController();
  String? archivoAdjunto; // Guardar nombre del archivo

  Future<void> _adjuntarArchivo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      setState(() {
        archivoAdjunto = result.files.single.name;
      });
    }
  }

  void _enviarSolicitud() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text("✅ Solicitud Enviada"),
            content: const Text("Su solicitud ha sido enviada exitosamente."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Cierra el diálogo
                  Navigator.pop(context); // Regresa a la página principal
                },
                child: const Text("Aceptar"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generar Permiso"),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      backgroundColor: const Color(0xFFEFFAE6),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 6,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Solicitud de Permiso",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Datos del aprendiz
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "👤 Nombres y Apellidos: Camilo Andrez Hernandez",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "🆔 C.C: 1065433322",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 6),
                      Text("📌 Ficha: 2877051", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 6),
                      Text(
                        "📅 Desde: 28/09/2024",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "📅 Hasta: 30/09/2024",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Caja de texto motivo
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Motivo:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: motivoController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: "Escriba aquí el motivo de su solicitud...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF9F9F9),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Adjuntar archivo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _adjuntarArchivo,
                        icon: const Icon(Icons.attach_file),
                        label: const Text("Adjuntar archivo"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[100],
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (archivoAdjunto != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "📎 Archivo adjunto: $archivoAdjunto",
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),

                  const SizedBox(height: 30),

                  // Botón enviar
                  ElevatedButton(
                    onPressed: _enviarSolicitud,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 60,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      "Enviar",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
