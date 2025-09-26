//Pantalla de los aprendices registrados seguir diseño figma
//Dentro de esta pantalla hacer el filtro
import 'package:flutter/material.dart';
import '../../../services/api_service.dart';

class AprendicesRegistrados extends StatefulWidget {
  const AprendicesRegistrados({super.key});

  @override
  State<AprendicesRegistrados> createState() => _AprendicesRegistradosState();
}

class _AprendicesRegistradosState extends State<AprendicesRegistrados> {
  List<Map<String, dynamic>> allApprentices = [];
  List<Map<String, dynamic>> filteredApprentices = [];
  String searchQuery = '';
  String sortOrder = 'A-Z';
  String photoFilter = 'Todos';
  String etapaFilter = 'Todas';
  int _selectedIndex = 1; // Índice del perfil seleccionado
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAprendices();
  }

  Future<void> _fetchAprendices() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final res = await ApiService.getAprendices();
      final List<dynamic> data = res['data'] ?? [];
      final list = data.map<Map<String, dynamic>>((u) => {
            'user_id': u['user_id'],
            'user_num_ident': u['user_num_ident'],
            'user_name': u['user_name'] ?? '',
            'user_ape': u['user_ape'] ?? '',
            'user_email': u['user_email'] ?? '',
            'user_tel': u['user_tel'] ?? '',
            'user_rol': u['user_rol'] ?? 'Aprendiz',
            'user_discap': u['user_discap'] ?? 'Ninguna',
            'etp_form_Apr': u['etp_form_Apr'] ?? 'Lectiva',
            'user_gen': u['user_gen'] ?? 'Masculino',
            'user_etn': u['user_etn'] ?? 'No Aplica',
            'user_img': u['user_img'] ?? 'default.png',
            'fec_ini_form_Apr': u['fec_ini_form_Apr'],
            'fec_fin_form_Apr': u['fec_fin_form_Apr'],
            'ficha_Apr': u['ficha_Apr'] ?? 0,
            'fec_registro': u['fec_registro'],
            'hasPhoto': (u['user_img'] ?? 'default.png') != 'default.png',
          }).toList();
      setState(() {
        allApprentices = list;
        filteredApprentices = List.from(allApprentices);
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'No se pudieron cargar los aprendices: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _applyFilters() {
    setState(() {
      // Filtrar por búsqueda (nombre, apellido, email, ficha)
      filteredApprentices =
          allApprentices.where((apprentice) {
            final searchLower = searchQuery.toLowerCase();
            return apprentice['user_name'].toLowerCase().contains(
                  searchLower,
                ) ||
                apprentice['user_ape'].toLowerCase().contains(searchLower) ||
                apprentice['user_email'].toLowerCase().contains(searchLower) ||
                apprentice['ficha_Apr'].toString().contains(searchQuery) ||
                apprentice['user_num_ident'].toString().contains(searchQuery);
          }).toList();

      // Filtrar por foto
      if (photoFilter == 'Con foto') {
        filteredApprentices =
            filteredApprentices
                .where((apprentice) => apprentice['hasPhoto'] == true)
                .toList();
      } else if (photoFilter == 'Sin foto') {
        filteredApprentices =
            filteredApprentices
                .where((apprentice) => apprentice['hasPhoto'] == false)
                .toList();
      }

      // Filtrar por etapa formativa
      if (etapaFilter == 'Lectiva') {
        filteredApprentices =
            filteredApprentices
                .where((apprentice) => apprentice['etp_form_Apr'] == 'Lectiva')
                .toList();
      } else if (etapaFilter == 'Productiva') {
        filteredApprentices =
            filteredApprentices
                .where(
                  (apprentice) => apprentice['etp_form_Apr'] == 'Productiva',
                )
                .toList();
      }

      // Ordenar por nombre completo
      if (sortOrder == 'A-Z') {
        filteredApprentices.sort((a, b) {
          final fullNameA = '${a['user_name']} ${a['user_ape']}';
          final fullNameB = '${b['user_name']} ${b['user_ape']}';
          return fullNameA.compareTo(fullNameB);
        });
      } else {
        filteredApprentices.sort((a, b) {
          final fullNameA = '${a['user_name']} ${a['user_ape']}';
          final fullNameB = '${b['user_name']} ${b['user_ape']}';
          return fullNameB.compareTo(fullNameA);
        });
      }
    });
  }

  void _showFilterModal() {
    String tempSearchQuery = searchQuery;
    String tempSortOrder = sortOrder;
    String tempPhotoFilter = photoFilter;
    String tempEtapaFilter = etapaFilter;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setModalState) => Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.75,
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header del modal
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Filtros',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.close,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Información del modal
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Text(
                            'La búsqueda principal se realiza desde el campo de arriba. Aquí puedes configurar filtros adicionales.',
                            style: TextStyle(
                              color: Colors.blue.shade800,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Ordenar
                        const Text(
                          'Ordenar por:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text('A-Z'),
                                value: 'A-Z',
                                groupValue: tempSortOrder,
                                onChanged: (value) {
                                  setModalState(() {
                                    tempSortOrder = value!;
                                  });
                                },
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text('Z-A'),
                                value: 'Z-A',
                                groupValue: tempSortOrder,
                                onChanged: (value) {
                                  setModalState(() {
                                    tempSortOrder = value!;
                                  });
                                },
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Filtro por foto
                        const Text(
                          'Filtrar por foto:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: tempPhotoFilter,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          items:
                              ['Todos', 'Con foto', 'Sin foto'].map((
                                String value,
                              ) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setModalState(() {
                              tempPhotoFilter = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        // Filtro por etapa formativa
                        const Text(
                          'Filtrar por etapa:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: tempEtapaFilter,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          items:
                              ['Todas', 'Lectiva', 'Productiva'].map((
                                String value,
                              ) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setModalState(() {
                              tempEtapaFilter = value!;
                            });
                          },
                        ),

                        const SizedBox(height: 20),

                        // Botones de acción
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  // Limpiar filtros
                                  tempSearchQuery = '';
                                  tempSortOrder = 'A-Z';
                                  tempPhotoFilter = 'Todos';
                                  tempEtapaFilter = 'Todas';
                                  setModalState(() {});
                                },
                                child: const Text(
                                  'Limpiar',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Aplicar filtros
                                  searchQuery = tempSearchQuery;
                                  sortOrder = tempSortOrder;
                                  photoFilter = tempPhotoFilter;
                                  etapaFilter = tempEtapaFilter;
                                  _applyFilters();
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4CAF50),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Aplicar Filtros',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
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
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Aprendices Registrados',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leadingWidth: 56,
      ),
      body: Container(
        color: const Color(0xFFF6FBE4),
        child: Padding(
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
                      // Campo de búsqueda
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                              _applyFilters();
                            });
                          },
                          decoration: InputDecoration(
                            hintText:
                                'Buscar por nombre, apellido, email, ficha...',
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

                      // Filter Button
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: ElevatedButton(
                          onPressed: _showFilterModal,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.filter_alt_outlined, size: 20),
                            ],
                          ),
                        ),
                      ),

                      // Indicador de resultados
                      if (searchQuery.isNotEmpty ||
                          photoFilter != 'Todos' ||
                          etapaFilter != 'Todas')
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Mostrando ${filteredApprentices.length} de ${allApprentices.length} aprendices',
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                        ),

                      // Información sobre la funcionalidad
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
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
                                'Toca en cualquier aprendiz para ver su perfil completo',
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

                      // Apprentices List
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _fetchAprendices,
                          child: _isLoading
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
                                  : filteredApprentices.isEmpty
                                ? const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_off,
                                        size: 64,
                                        color: Colors.black54,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'No se encontraron aprendices',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                : ListView.builder(
                                  itemCount: filteredApprentices.length,
                                  itemBuilder: (context, index) {
                                    final apprentice =
                                        filteredApprentices[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/vista-aprendiz',
                                          arguments: apprentice,
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.3,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withValues(
                                              alpha: 0.5,
                                            ),
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
                                              child: const Icon(
                                                Icons.person,
                                                color: Colors.black,
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
                                                    '${apprentice['user_name']} ${apprentice['user_ape']}',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 1.2,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    'Ficha: ${apprentice['ficha_Apr']} | ${apprentice['etp_form_Apr']}',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${apprentice['user_email']}',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withValues(
                                                  alpha: 0.2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: const Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.black54,
                                                size: 16,
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
              const SizedBox(height: 16),
            ],
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
