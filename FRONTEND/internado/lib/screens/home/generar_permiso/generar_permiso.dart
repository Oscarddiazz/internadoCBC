import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../services/api_service.dart';

class GenerarPermisoPage extends StatefulWidget {
  const GenerarPermisoPage({super.key});

  @override
  State<GenerarPermisoPage> createState() => _GenerarPermisoPageState();
}

class _GenerarPermisoPageState extends State<GenerarPermisoPage> {
  final TextEditingController motivoController = TextEditingController();
  String? archivoAdjunto; // Guardar nombre del archivo
  bool _isLoading = false;
  Map<String, dynamic>? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final res = await ApiService.getProfile();
      if (res['success'] == true) {
        setState(() {
          _userProfile = res['data'];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar perfil: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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

  Future<void> _enviarSolicitud() async {
    final motivo = motivoController.text.trim();
    if (motivo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa el motivo del permiso'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final res = await ApiService.createPermiso(
        motivo: motivo,
        evidencia: archivoAdjunto,
      );

      if (res['success'] == true) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('✅ Solicitud Enviada'),
            content: Text(res['message'] ?? 'Solicitud enviada exitosamente.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Aceptar'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res['message'] ?? 'Error al crear permiso'),
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
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
                    children: [
                      Text(
                        "👤 Nombres y Apellidos: ${_userProfile != null ? '${_userProfile!['user_name']} ${_userProfile!['user_ape']}' : 'Cargando...'}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "🆔 C.C: ${_userProfile?['user_num_ident'] ?? 'Cargando...'}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "📌 Ficha: ${_userProfile?['ficha_Apr'] ?? 'Cargando...'}", 
                        style: const TextStyle(fontSize: 16)
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "📅 Desde: ${_userProfile?['fec_ini_form_Apr'] ?? 'Cargando...'}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "📅 Hasta: ${_userProfile?['fec_fin_form_Apr'] ?? 'Cargando...'}",
                        style: const TextStyle(fontSize: 16),
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
                    onPressed: _isLoading ? null : _enviarSolicitud,
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
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
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
