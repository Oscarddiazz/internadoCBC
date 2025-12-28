import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import 'detalle_tarea.dart'; // 👈 Importa la otra página

class TareasDirigidasPage extends StatefulWidget {
  const TareasDirigidasPage({super.key});

  @override
  State<TareasDirigidasPage> createState() => _TareasDirigidasPageState();
}

class _TareasDirigidasPageState extends State<TareasDirigidasPage> {
  List<Map<String, dynamic>> tasks = [];
  bool _isLoading = false;
  String? _errorMessage;
  String filtro = "pedido"; // pedido (default) o nombre
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
        // Cargar tareas después de obtener el perfil
        _fetchTareas();
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

  Future<void> _fetchTareas() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      // Solo obtener tareas del aprendiz autenticado
      final res = await ApiService.getTareasByAprendiz(
        _userProfile?['user_id'] ?? 0,
      );
      final List<dynamic> data = res['data'] ?? [];
      final mapped =
          data.map<Map<String, dynamic>>((t) {
            return {
              'id': t['tarea_id'],
              'name': t['tarea_descripcion'] ?? 'Tarea',
              // Colorear por estado
              'color': _colorForEstado(
                (t['tarea_estado'] ?? 'Pendiente').toString(),
              ),
              'hora': (t['tarea_fec_entrega'] ?? '').toString(),
              'raw': t,
            };
          }).toList();
      setState(() {
        tasks = mapped;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'No se pudieron cargar las tareas: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Color _colorForEstado(String estado) {
    switch (estado.toLowerCase()) {
      case 'completada':
        return const Color(0xFF22FB00);
      case 'en progreso':
        return const Color(0xFFFADD00);
      case 'pendiente':
      default:
        return const Color(0xFFFB0000);
    }
  }

  void _aplicarFiltro(String nuevoFiltro) {
    setState(() {
      filtro = nuevoFiltro;
      if (filtro == "nombre") {
        tasks.sort((a, b) => a["name"].compareTo(b["name"]));
      } else {
        tasks.sort((a, b) => (a["id"] as int).compareTo(b["id"] as int));
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
                    _userProfile != null
                        ? "${_userProfile!['user_name']} ${_userProfile!['user_ape']}"
                        : "Cargando...",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "📄 Documento: ${_userProfile?['user_num_ident'] ?? 'Cargando...'}",
                  ),
                  Text(
                    "📧 Correo: ${_userProfile?['user_email'] ?? 'Cargando...'}",
                  ),
                  Text(
                    "📞 Teléfono: ${_userProfile?['user_tel'] ?? 'Cargando...'}",
                  ),
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
                      child: RefreshIndicator(
                        onRefresh: _fetchTareas,
                        child:
                            _isLoading
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
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
                                : tasks.isEmpty
                                ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.assignment_outlined,
                                          size: 64,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          "No tienes tareas asignadas",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "Las tareas aparecerán aquí cuando te sean asignadas",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                : ListView.separated(
                                  itemCount: tasks.length,
                                  separatorBuilder:
                                      (context, index) =>
                                          const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final task = tasks[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => DetalleTareaPage(
                                                  taskId: task["id"] as int,
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
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
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
