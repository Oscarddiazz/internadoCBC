import 'package:flutter/material.dart';

class ReporteAprendiz extends StatefulWidget {
  const ReporteAprendiz({super.key});

  @override
  State<ReporteAprendiz> createState() => _ReporteAprendizState();
}

class _ReporteAprendizState extends State<ReporteAprendiz> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _horaAcordadaController = TextEditingController();
  final TextEditingController _horaVerificacionController =
      TextEditingController();
  final TextEditingController _lugarController = TextEditingController();
  final TextEditingController _detallesIncidenteController =
      TextEditingController();
  final TextEditingController _advertenciasSancionesController =
      TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _fechaController.dispose();
    _horaAcordadaController.dispose();
    _horaVerificacionController.dispose();
    _lugarController.dispose();
    _detallesIncidenteController.dispose();
    _advertenciasSancionesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FBE4),
      body: Column(
        children: [
          // Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 24),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Reporte Aprendiz',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E8E8),
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 20,
                              color: Colors.grey,
                            ),
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.save_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 60,
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          'Tu reporte se ha generado',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            minimumSize: const Size(200, 45),
                                          ),
                                          child: const Text(
                                            'Aceptar',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Informacion del Aprendiz
                    _buildFormField(
                      'Nombre:',
                      _nombreController,
                      'Ingrese el nombre completo',
                    ),
                    const SizedBox(height: 12),
                    _buildDateField('Fecha:', _fechaController),
                    const SizedBox(height: 12),
                    _buildTimeField('Hora Acordada:', _horaAcordadaController),
                    const SizedBox(height: 12),
                    _buildTimeField(
                      'Hora de Verificación:',
                      _horaVerificacionController,
                    ),
                    const SizedBox(height: 12),
                    _buildFormField(
                      'Lugar:',
                      _lugarController,
                      'Ingrese el lugar',
                    ),

                    const SizedBox(height: 32),

                    // Detalles del incidente
                    const Text(
                      'Detalles del incidente',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextArea(
                      _detallesIncidenteController,
                      'Describa los detalles del incidente...',
                      4,
                    ),

                    const SizedBox(height: 24),

                    // Sanciones o Avertencias
                    const Text(
                      'Advertencias y Sanciones',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextArea(
                      _advertenciasSancionesController,
                      'Describa las advertencias y sanciones...',
                      6,
                    ),

                    const SizedBox(height: 100), // Space for bottom navigation
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/admin-dashboard');
              },
              child: const Icon(Icons.home, size: 24, color: Colors.black),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/perfil');
              },
              child: const Icon(Icons.person, size: 24, color: Colors.black),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/configuracion');
              },
              child: const Icon(Icons.settings, size: 24, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Methods

  Widget _buildFormField(
    String label,
    TextEditingController controller,
    String placeholder,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.black, fontSize: 14),
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.black, fontSize: 14),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );

                if (pickedDate != null) {
                  controller.text =
                      '${pickedDate.day.toString().padLeft(2, '0')}/'
                      '${pickedDate.month.toString().padLeft(2, '0')}/'
                      '${pickedDate.year}';
                }
              },
              readOnly: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField(String label, TextEditingController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.black, fontSize: 14),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (pickedTime != null) {
                  controller.text =
                      '${pickedTime.hour.toString().padLeft(2, '0')}:'
                      '${pickedTime.minute.toString().padLeft(2, '0')}';
                }
              },
              readOnly: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextArea(
    TextEditingController controller,
    String placeholder,
    int maxLines,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black, fontSize: 14, height: 1.5),
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
