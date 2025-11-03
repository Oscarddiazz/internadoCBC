import 'package:flutter/material.dart';

class ReporteAprendizPage extends StatefulWidget {
  const ReporteAprendizPage({super.key});

  @override
  State<ReporteAprendizPage> createState() => _ReporteAprendizPageState();
}

class _ReporteAprendizPageState extends State<ReporteAprendizPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> filteredStudents = [];

  final List<String> students = const [
    "Adrián Esteban Morales Pineda",
    "Camila Alejandra Rojas Martinez",
    "Lucía Fernanda Fernández Ortega",
    "Nicolás Eduardo Torres Jiménez",
    "Oscar David Diaz Alvarez",
    "María José López García",
    "Juan Carlos Ramírez Soto",
    "Ana Gabriela Mendoza Ruiz",
    "Pedro Antonio Vargas León",
    "Valentina Isabel Castro Mora",
    "Diego Alejandro Herrera Paz",
    "Sofia Carolina Mendez Vargas",
    "Carlos Eduardo Quintero Ríos",
    "Isabella Andrea Pérez Luna",
    "Gabriel Sebastián Silva Torres",
  ];

  @override
  void initState() {
    super.initState();
    filteredStudents = students;
    _searchController.addListener(_filterStudents);
  }

  void _filterStudents() {
    String searchTerm = _searchController.text.toLowerCase();
    setState(() {
      filteredStudents =
          students
              .where((student) => student.toLowerCase().contains(searchTerm))
              .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FBE4),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[300]!, width: 1)),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 55,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/admin-dashboard');
                  },
                  child: const Icon(Icons.home, size: 26, color: Colors.black),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/perfil');
                  },
                  child: const Icon(
                    Icons.person,
                    size: 26,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/configuracion');
                  },
                  child: const Icon(
                    Icons.settings,
                    size: 26,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.chevron_left,
                      size: 28,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Reporte Aprendiz',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar aprendiz...',
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Create New Report Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Crear nuevo reporte',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/crear-reporte');
                          },
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.green[400],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 22,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Student List
                    Expanded(
                      child: ListView.separated(
                        itemCount: filteredStudents.length,
                        separatorBuilder:
                            (context, index) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // Aquí se manejará la selección del aprendiz
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black12),
                              ),
                              child: Text(
                                filteredStudents[index],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
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
          ],
        ),
      ),
    );
  }
}
