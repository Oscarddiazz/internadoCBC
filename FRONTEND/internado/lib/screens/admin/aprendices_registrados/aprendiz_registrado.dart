//Pantalla de los aprendices registrados seguir diseño figma
//Dentro de esta pantalla hacer el filtro
import 'package:flutter/material.dart';

class AprendicesRegistrados extends StatefulWidget {
  const AprendicesRegistrados({super.key});

  @override
  State<AprendicesRegistrados> createState() => _AprendicesRegistradosState();
}

class _AprendicesRegistradosState extends State<AprendicesRegistrados> {
  final List<Map<String, dynamic>> allApprentices = [
    {
      "user_id": 1,
      "user_num_ident": "123456789",
      "user_name": "Adrian Esteban",
      "user_ape": "Morales Pineda",
      "user_email": "adrian.morales@test.com",
      "user_tel": "3001234567",
      "user_rol": "Aprendiz",
      "user_discap": "Ninguna",
      "etp_form_Apr": "Lectiva",
      "user_gen": "Masculino",
      "user_etn": "No Aplica",
      "user_img": "default.png",
      "fec_ini_form_Apr": "2024-01-15",
      "fec_fin_form_Apr": "2025-01-15",
      "ficha_Apr": 123456,
      "fec_registro": "2024-01-10",
      "hasPhoto": false,
    },
    {
      "user_id": 2,
      "user_num_ident": "987654321",
      "user_name": "Camila Alejandra",
      "user_ape": "Rojas Martínez",
      "user_email": "camila.rojas@test.com",
      "user_tel": "3009876543",
      "user_rol": "Aprendiz",
      "user_discap": "Ninguna",
      "etp_form_Apr": "Productiva",
      "user_gen": "Femenino",
      "user_etn": "No Aplica",
      "user_img": "default.png",
      "fec_ini_form_Apr": "2024-02-01",
      "fec_fin_form_Apr": "2025-02-01",
      "ficha_Apr": 654321,
      "fec_registro": "2024-01-25",
      "hasPhoto": true,
    },
    {
      "user_id": 3,
      "user_num_ident": "456789123",
      "user_name": "Juan Camilo",
      "user_ape": "Hernández Navarro",
      "user_email": "juan.hernandez@test.com",
      "user_tel": "3004567891",
      "user_rol": "Aprendiz",
      "user_discap": "Ninguna",
      "etp_form_Apr": "Lectiva",
      "user_gen": "Masculino",
      "user_etn": "No Aplica",
      "user_img": "default.png",
      "fec_ini_form_Apr": "2024-01-20",
      "fec_fin_form_Apr": "2025-01-20",
      "ficha_Apr": 789123,
      "fec_registro": "2024-01-15",
      "hasPhoto": false,
    },
    {
      "user_id": 4,
      "user_num_ident": "789123456",
      "user_name": "Lucía Fernanda",
      "user_ape": "Fernández Ortega",
      "user_email": "lucia.fernandez@test.com",
      "user_tel": "3007891234",
      "user_rol": "Aprendiz",
      "user_discap": "Ninguna",
      "etp_form_Apr": "Productiva",
      "user_gen": "Femenino",
      "user_etn": "No Aplica",
      "user_img": "default.png",
      "fec_ini_form_Apr": "2024-02-15",
      "fec_fin_form_Apr": "2025-02-15",
      "ficha_Apr": 456789,
      "fec_registro": "2024-02-01",
      "hasPhoto": true,
    },
    {
      "user_id": 5,
      "user_num_ident": "321654987",
      "user_name": "Nicolás Eduardo",
      "user_ape": "Torres Jiménez",
      "user_email": "nicolas.torres@test.com",
      "user_tel": "3003216549",
      "user_rol": "Aprendiz",
      "user_discap": "Ninguna",
      "etp_form_Apr": "Lectiva",
      "user_gen": "Masculino",
      "user_etn": "No Aplica",
      "user_img": "default.png",
      "fec_ini_form_Apr": "2024-01-25",
      "fec_fin_form_Apr": "2025-01-25",
      "ficha_Apr": 321654,
      "fec_registro": "2024-01-20",
      "hasPhoto": false,
    },
    {
      "user_id": 6,
      "user_num_ident": "654987321",
      "user_name": "Oscar David",
      "user_ape": "Díaz Alvarez",
      "user_email": "oscar.diaz@test.com",
      "user_tel": "3006549873",
      "user_rol": "Aprendiz",
      "user_discap": "Ninguna",
      "etp_form_Apr": "Productiva",
      "user_gen": "Masculino",
      "user_etn": "No Aplica",
      "user_img": "default.png",
      "fec_ini_form_Apr": "2024-03-01",
      "fec_fin_form_Apr": "2025-03-01",
      "ficha_Apr": 654987,
      "fec_registro": "2024-02-15",
      "hasPhoto": false,
    },
  ];

  List<Map<String, dynamic>> filteredApprentices = [];
  String searchQuery = '';
  String sortOrder = 'A-Z';
  String photoFilter = 'Todos';
  String etapaFilter = 'Todas';
  int _selectedIndex = 1; // Índice del perfil seleccionado

  @override
  void initState() {
    super.initState();
    filteredApprentices = List.from(allApprentices);
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
                apprentice['user_num_ident'].contains(searchQuery);
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
                        child:
                            filteredApprentices.isEmpty
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
