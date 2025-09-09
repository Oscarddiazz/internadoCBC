//Pantalla donde se crean los reportes como balances o informes, los 3 diseños de figma implementarlos en est solo archivo
import 'package:flutter/material.dart';
import 'reporte_general_fecha.dart';

class ReporteGeneral extends StatefulWidget {
  @override
  _ReporteGeneralState createState() => _ReporteGeneralState();
}

class _ReporteGeneralState extends State<ReporteGeneral> {
  List<String> selectedOptions = [];
  bool showAdvanced = true;

  void toggleOption(String option) {
    setState(() {
      if (selectedOptions.contains(option)) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.add(option);
      }
    });
  }

  final List<String> mainOptions = [
    "Aprendices Activos Totales",
    "Cupos Actuales Usados",
    "Total de Comidas Entregadas",
    "Total de Permisos (Apr. y Neg.)",
    "Total de Tareas Realizadas",
  ];

  final List<String> advancedOptions = ["Aprendices Egresados del Internado"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6FBE4),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.chevron_left,
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 16),
                  Text(
                    "Reporte General",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Center(
                            child: Text(
                              "Bienvenido(a) a la\nCreación de Reportes",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ),
                          SizedBox(height: 24),

                          // Subtitle
                          Text(
                            "Seleccione los datos que recolectará el Reporte:",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          SizedBox(height: 32),

                          // Main Options
                          ...mainOptions
                              .map(
                                (option) => Padding(
                                  padding: EdgeInsets.only(bottom: 16),
                                  child: GestureDetector(
                                    onTap: () => toggleOption(option),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 2,
                                            ),
                                            color:
                                                selectedOptions.contains(option)
                                                    ? Colors.black
                                                    : Colors.white,
                                          ),
                                          child:
                                              selectedOptions.contains(option)
                                                  ? Center(
                                                    child: Container(
                                                      width: 12,
                                                      height: 12,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  )
                                                  : null,
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: Text(
                                            option,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),

                          SizedBox(height: 8),

                          // Advanced Section
                          GestureDetector(
                            onTap:
                                () => setState(
                                  () => showAdvanced = !showAdvanced,
                                ),
                            child: Row(
                              children: [
                                Transform.rotate(
                                  angle: showAdvanced ? 3.14159 : 0,
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Avanzado",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (showAdvanced) ...[
                            SizedBox(height: 16),
                            ...advancedOptions
                                .map(
                                  (option) => Padding(
                                    padding: EdgeInsets.only(bottom: 16),
                                    child: GestureDetector(
                                      onTap: () => toggleOption(option),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.black,
                                                width: 2,
                                              ),
                                              color:
                                                  selectedOptions.contains(
                                                        option,
                                                      )
                                                      ? Colors.black
                                                      : Colors.white,
                                            ),
                                            child:
                                                selectedOptions.contains(option)
                                                    ? Center(
                                                      child: Container(
                                                        width: 12,
                                                        height: 12,
                                                        decoration:
                                                            BoxDecoration(
                                                              shape:
                                                                  BoxShape
                                                                      .circle,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                      ),
                                                    )
                                                    : null,
                                          ),
                                          SizedBox(width: 16),
                                          Expanded(
                                            child: Text(
                                              option,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ],
                        ],
                      ),
                    ),

                    // Forward Arrow
                    Positioned(
                      bottom: 24,
                      right: 24,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReporteGeneralFecha(),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.chevron_right,
                          size: 32,
                          color: Colors.black,
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

      // Bottom Navigation
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
                    // Handle user navigation
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
    );
  }
}
