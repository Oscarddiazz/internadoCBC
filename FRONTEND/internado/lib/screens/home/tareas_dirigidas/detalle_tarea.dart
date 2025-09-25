import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class DetalleTareaPage extends StatefulWidget {
  final String nombre;
  final String hora;

  const DetalleTareaPage({super.key, required this.nombre, required this.hora});

  @override
  State<DetalleTareaPage> createState() => _DetalleTareaPageState();
}

class _DetalleTareaPageState extends State<DetalleTareaPage> {
  String? archivoSeleccionado;

  Future<void> _seleccionarArchivo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
    );

    if (result != null) {
      setState(() {
        archivoSeleccionado = result.files.single.name;
      });

      // Mostrar mensaje emergente
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text("✅ Evidencia enviada"),
              content: Text(
                "Se ha adjuntado el archivo:\n\n$archivoSeleccionado",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cierra el dialogo
                    Navigator.pop(context); // Regresa a la página anterior
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FBE4),
      appBar: AppBar(
        title: const Text("Detalle de Tarea"),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nombre: Nicolás Eduardo Torres Jiménez",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Tarea: ${widget.nombre}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                "Hora Asignada: ${widget.hora}",
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 10),
              const Text(
                "Estado: Pendiente",
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
              const SizedBox(height: 10),
              const Text("Lugar: Casino CBC", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),

              // Caja de solo lectura con detalles
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Detalles de la tarea",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "A la hora indicada se espera que el aprendiz cumpla con la labor asignada. "
                      "El incumplimiento será registrado.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _seleccionarArchivo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 30,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  icon: const Icon(Icons.attach_file, color: Colors.white),
                  label: const Text(
                    "Enviar Evidencia",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
