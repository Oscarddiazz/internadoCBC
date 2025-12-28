//Pantalla donde se ven los documentos cargados por otros admins
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class VisualizarDocumentos extends StatefulWidget {
  const VisualizarDocumentos({super.key});

  @override
  State<VisualizarDocumentos> createState() => _VisualizarDocumentosState();
}

class _VisualizarDocumentosState extends State<VisualizarDocumentos> {
  // Lista simulada de documentos (orden original representa "pedido" - más viejo -> nuevo)
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

  // Lista mostrada (filtrada)
  List<Map<String, String>> filteredDocs = [];

  String searchQuery = '';
  String sortOrder = 'A-Z'; // 'A-Z' | 'Z-A' | 'pedido' (pedido = original)
  String typeFilter = 'Todos'; // 'Todos' | 'PDF' | 'Word' | 'Imagen' | 'Excel'

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    filteredDocs = List.from(_documentos);
  }

  Future<void> _abrirDocumento(String ruta) async {
    final result = await OpenFile.open(ruta);
    debugPrint("Resultado al abrir archivo: ${result.message}");
  }

  void _applyFilters() {
    List<Map<String, String>> temp =
        _documentos.where((doc) {
          final searchLower = searchQuery.toLowerCase();
          final nombre = doc['nombre']!.toLowerCase();
          final tipo = doc['tipo']!.toLowerCase();
          return nombre.contains(searchLower) || tipo.contains(searchLower);
        }).toList();

    if (typeFilter != 'Todos') {
      temp =
          temp
              .where(
                (d) => d['tipo']!.toLowerCase() == typeFilter.toLowerCase(),
              )
              .toList();
    }

    if (sortOrder == 'A-Z') {
      temp.sort((a, b) => a['nombre']!.compareTo(b['nombre']!));
    } else if (sortOrder == 'Z-A') {
      temp.sort((a, b) => b['nombre']!.compareTo(a['nombre']!));
    } else {
      // 'pedido' = mantener orden original según _documentos
      temp.sort((a, b) {
        final ai = _documentos.indexWhere((x) => x['nombre'] == a['nombre']);
        final bi = _documentos.indexWhere((x) => x['nombre'] == b['nombre']);
        return ai.compareTo(bi);
      });
    }

    setState(() {
      filteredDocs = temp;
    });
  }

  void _showFilterModal() {
    String tempSort = sortOrder;
    String tempType = typeFilter;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setModalState) => Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Filtros',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Orden
                        const Text(
                          'Ordenar por:',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        RadioListTile<String>(
                          title: const Text('A - Z'),
                          value: 'A-Z',
                          groupValue: tempSort,
                          onChanged: (v) => setModalState(() => tempSort = v!),
                          contentPadding: EdgeInsets.zero,
                        ),
                        RadioListTile<String>(
                          title: const Text('Z - A'),
                          value: 'Z-A',
                          groupValue: tempSort,
                          onChanged: (v) => setModalState(() => tempSort = v!),
                          contentPadding: EdgeInsets.zero,
                        ),
                        RadioListTile<String>(
                          title: const Text('Pedido (viejo → nuevo)'),
                          value: 'pedido',
                          groupValue: tempSort,
                          onChanged: (v) => setModalState(() => tempSort = v!),
                          contentPadding: EdgeInsets.zero,
                        ),
                        const SizedBox(height: 12),
                        // Tipo
                        const Text(
                          'Filtrar por tipo:',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: tempType,
                          items:
                              ['Todos', 'PDF', 'Word', 'Imagen', 'Excel']
                                  .map(
                                    (t) => DropdownMenuItem(
                                      value: t,
                                      child: Text(t),
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              (v) =>
                                  setModalState(() => tempType = v ?? 'Todos'),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  setModalState(() {
                                    tempSort = 'A-Z';
                                    tempType = 'Todos';
                                  });
                                },
                                child: const Text(
                                  'Limpiar',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: () {
                                  sortOrder = tempSort;
                                  typeFilter = tempType;
                                  _applyFilters();
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4CAF50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                                child: const Text(
                                  'Aplicar Filtros',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
          ),
    );
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
          "Visualizar Documentos",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leadingWidth: 56,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Search field
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: TextField(
                        onChanged: (v) {
                          searchQuery = v;
                          _applyFilters();
                        },
                        decoration: InputDecoration(
                          hintText: 'Buscar por nombre o tipo...',
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey[600],
                          ),
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
                    ),

                    // Filter button
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ElevatedButton(
                        onPressed: _showFilterModal,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Filtrar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.filter_alt_outlined, size: 20),
                          ],
                        ),
                      ),
                    ),

                    // Indicador de resultados (solo si hay búsqueda o filtro distinto)
                    if (searchQuery.isNotEmpty ||
                        typeFilter != 'Todos' ||
                        sortOrder != 'A-Z')
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Mostrando ${filteredDocs.length} de ${_documentos.length} documentos',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                      ),

                    // Info azul
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Selecciona un documento para visualizarlo con la aplicación nativa',
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Document list or empty state
                    Expanded(
                      child:
                          filteredDocs.isEmpty
                              ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.insert_drive_file,
                                      size: 64,
                                      color: Colors.black54,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'No se encontraron documentos',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : ListView.builder(
                                itemCount: filteredDocs.length,
                                itemBuilder: (context, index) {
                                  final doc = filteredDocs[index];
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.5),
                                        width: 1,
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 64,
                                          height: 64,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            _getIcono(doc["tipo"]!),
                                            color: Colors.green,
                                            size: 32,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                doc["nombre"]!,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  height: 1.2,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "Tipo: ${doc["tipo"]}",
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.visibility,
                                            color: Colors.black54,
                                          ),
                                          onPressed:
                                              () =>
                                                  _abrirDocumento(doc["ruta"]!),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
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
