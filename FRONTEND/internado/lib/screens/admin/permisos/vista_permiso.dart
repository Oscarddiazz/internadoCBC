import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../services/api_service.dart';

class VistaPermiso extends StatefulWidget {
  final int permisoId;
  final Map<String, String> solicitud;

  const VistaPermiso({
    super.key,
    required this.permisoId,
    required this.solicitud,
  });

  @override
  State<VistaPermiso> createState() => _VistaPermisoState();
}

class _VistaPermisoState extends State<VistaPermiso> {
  String? estado; // "Aprobado" o "Denegado"
  String? evidencia;
  File? firmaImg;

  final ImagePicker _picker = ImagePicker();

  void _seleccionarEvidencia() {
    setState(() {
      evidencia = "Documento.pdf";
    });
  }

  // Variables para el BottomNavigationBar
  int _selectedIndex = 0; // Variable para controlar el índice seleccionado

  Future<void> _firmar() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery, // o ImageSource.camera
    );

    if (image != null) {
      setState(() {
        firmaImg = File(image.path);
      });
    }
  }

  Future<void> _enviar() async {
    if (estado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Debes confirmar o denegar el permiso"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final res = await ApiService.respondToPermiso(
        permisoId: widget.permisoId,
        respuesta: estado!.toLowerCase(),
      );

      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Solicitud ${estado!.toUpperCase()}.\n"
              "Razón: ${widget.solicitud['razon']}\n"
              "Evidencia: ${evidencia ?? "No adjunta"}\n"
              "Firma: ${firmaImg != null ? "Sí" : "No"}",
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res['message'] ?? 'Error al responder permiso'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error de conexión: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Detalle del Permiso',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Datos básicos
                Text(
                  widget.solicitud['nombre'] ?? '',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text("Fecha: ${widget.solicitud['fecha']}"),
                const SizedBox(height: 5),
                Text("Motivo: ${widget.solicitud['motivo']}"),
                const SizedBox(height: 20),

                // Razón fija
                const Text(
                  "Razón / Observaciones:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Text(widget.solicitud['razon'] ?? "Sin razón"),
                ),
                const SizedBox(height: 20),

                // Confirmar o Denegar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ChoiceChip(
                      label: const Text("Denegar"),
                      selected: estado == "Denegado",
                      selectedColor: Colors.red,
                      onSelected: (_) {
                        setState(() => estado = "Denegado");
                      },
                    ),
                    ChoiceChip(
                      label: const Text("Confirmar"),
                      selected: estado == "Aprobado",
                      selectedColor: Colors.green,
                      onSelected: (_) {
                        setState(() => estado = "Aprobado");
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Evidencia (PDF)
                Center(
                  child: ElevatedButton(
                    onPressed: _seleccionarEvidencia,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.black),
                      ),
                    ),
                    child: Text(evidencia ?? "Subir PDF de evidencia"),
                  ),
                ),
                const SizedBox(height: 20),

                // Firma con vista previa
                Center(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: _firmar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.black),
                          ),
                        ),
                        child: Text(
                          firmaImg != null ? "Cambiar firma" : "Subir firma",
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (firmaImg != null)
                        Container(
                          height: 100,
                          width: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: FileImage(firmaImg!),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const Spacer(),

                // Enviar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _enviar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Enviar", style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF6FBE4),
        elevation: 0,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          setState(() {
            _selectedIndex = index;
          });
          // Navegación según el índice seleccionado
          switch (index) {
            case 0: // Home
              Navigator.pushReplacementNamed(context, '/admin-dashboard');
              break;
            case 1: // Perfil
              Navigator.pushNamed(context, '/perfil-admin');
              break;
            case 2: // Configuración
              Navigator.pushNamed(context, '/configuracion-admin');
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
