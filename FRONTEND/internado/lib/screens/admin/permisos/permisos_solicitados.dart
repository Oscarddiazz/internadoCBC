import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import 'vista_permiso.dart'; // 👈 Importamos la nueva vista

class SolicitudesPermiso extends StatefulWidget {
  const SolicitudesPermiso({super.key});

  @override
  State<SolicitudesPermiso> createState() => _SolicitudesPermisoState();
}

class _SolicitudesPermisoState extends State<SolicitudesPermiso> {
  bool _isLoading = false;
  String? _errorMessage;
  int _selectedIndex = 0;

  List<Map<String, dynamic>> _solicitudes = [];
  List<Map<String, dynamic>> _filteredSolicitudes = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchSolicitudes();
  }

  Future<void> _fetchSolicitudes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final result = await ApiService.getPermisos();
      final List<dynamic> data = result['data'] ?? [];

      final solicitudes =
          data.map<Map<String, dynamic>>((item) {
            final String nombreAprendiz = _joinNames(
              item['aprendiz_name'],
              item['aprendiz_ape'],
            );
            return {
              'permiso_id': item['permiso_id'],
              'nombre': nombreAprendiz,
              'motivo': item['permiso_motivo'] ?? '-',
              'fecha': item['permiso_fec_solic'] ?? '',
              'detalles': item['permiso_evidencia'] ?? '',
              'raw': item,
            };
          }).toList();

      setState(() {
        _solicitudes = solicitudes;
        _filteredSolicitudes = List.from(_solicitudes);
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'No se pudieron cargar las solicitudes: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _joinNames(dynamic nombre, dynamic apellido) {
    final String n = (nombre ?? '').toString().trim();
    final String a = (apellido ?? '').toString().trim();
    if (n.isEmpty && a.isEmpty) return 'Aprendiz';
    if (a.isEmpty) return n;
    if (n.isEmpty) return a;
    return '$n $a';
  }

  void _applyFilters() {
    final searchLower = searchQuery.toLowerCase();
    setState(() {
      _filteredSolicitudes =
          _solicitudes.where((sol) {
            final nombre = (sol['nombre'] ?? '').toString().toLowerCase();
            final motivo = (sol['motivo'] ?? '').toString().toLowerCase();
            final fecha = (sol['fecha'] ?? '').toString().toLowerCase();
            return nombre.contains(searchLower) ||
                motivo.contains(searchLower) ||
                fecha.contains(searchLower);
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
              child: RefreshIndicator(
                onRefresh: _fetchSolicitudes,
                child:
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _errorMessage != null
                        ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                        : _filteredSolicitudes.isEmpty
                        ? const Center(
                          child: Text(
                            "No hay solicitudes encontradas",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                          ),
                        )
                        : ListView.builder(
                          itemCount: _filteredSolicitudes.length,
                          itemBuilder: (context, index) {
                            final solicitud = _filteredSolicitudes[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.black12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    solicitud['nombre'] ?? '-',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    solicitud['motivo'] ?? '-',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Fecha: ${solicitud['fecha'] ?? ''}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.black26),
                                    ),
                                    child: Text(
                                      solicitud['detalles'] ?? 'Sin detalles',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton.icon(
                                      icon: const Icon(
                                        Icons.visibility,
                                        size: 18,
                                      ),
                                      label: const Text("Ver más"),
                                      onPressed: () {
                                        final Map<String, String> solicitudStr =
                                            {
                                              'nombre':
                                                  (solicitud['nombre'] ?? '')
                                                      .toString(),
                                              'motivo':
                                                  (solicitud['motivo'] ?? '')
                                                      .toString(),
                                              'fecha':
                                                  (solicitud['fecha'] ?? '')
                                                      .toString(),
                                              'detalles':
                                                  (solicitud['detalles'] ?? '')
                                                      .toString(),
                                            };
                                        final int permisoId =
                                            (solicitud['permiso_id'] as int);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) => VistaPermiso(
                                                  permisoId: permisoId,
                                                  solicitud: solicitudStr,
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
              ),
            ),
          ],
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
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/admin-dashboard');
              break;
            case 1:
              Navigator.pushNamed(context, '/perfil-admin');
              break;
            case 2:
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
