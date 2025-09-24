import 'package:flutter/material.dart';

class ReporteAprendizPage extends StatefulWidget {
  const ReporteAprendizPage({Key? key}) : super(key: key);

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
          child: Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/admin-dashboard');
                  },
                  child: Icon(Icons.home, size: 24, color: Colors.black),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/perfil');
                  },
                  child: Icon(Icons.person, size: 24, color: Colors.black),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/configuracion');
                  },
                  child: Icon(Icons.settings, size: 24, color: Colors.black),
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.chevron_left,
                      size: 32,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Reporte Aprendiz',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar aprendiz...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
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
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/crear-reporte');
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 24,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Student List
                    Expanded(
                      child: ListView.separated(
                        itemCount: filteredStudents.length,
                        separatorBuilder:
                            (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // Handle student selection
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 24,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD9D9D9),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Text(
                                  filteredStudents[index],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    height: 1.2,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
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
