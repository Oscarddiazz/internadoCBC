import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class RegisterStep2Screen extends StatefulWidget {
  const RegisterStep2Screen({super.key});

  @override
  State<RegisterStep2Screen> createState() => _RegisterStep2ScreenState();
}

class _RegisterStep2ScreenState extends State<RegisterStep2Screen> {
  // Controladores para los campos de texto
  final TextEditingController _documentoController = TextEditingController();

  // Variables de estado
  String? _selectedDiscapacidad;
  String? _selectedEtnia;
  String? _selectedGenero;
  String? _selectedTipoDocumento;
  bool _isLoading = false;

  // Datos del paso anterior
  late Map<String, dynamic> _datosPaso1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        _datosPaso1 = args;
      }
    });
  }

  @override
  void dispose() {
    _documentoController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    // Validar campos requeridos
    if (_documentoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa tu número de documento'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_selectedTipoDocumento == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona el tipo de documento'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_selectedGenero == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona tu género'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Preparar datos del usuario combinando ambos pasos
      final userData = {
        'user_num_ident': _documentoController.text.trim(),
        'user_name': _datosPaso1['nombre'],
        'user_ape': _datosPaso1['apellidos'],
        'user_email': _datosPaso1['email'],
        'user_tel': _datosPaso1['telefono'],
        'user_pass': _datosPaso1['password'],
        'user_rol': _datosPaso1['rol'],
        'user_discap': _selectedDiscapacidad ?? 'Ninguna',
        'user_gen': _selectedGenero ?? 'Masculino',
        'user_etn': _selectedEtnia ?? 'No Aplica',
        'user_img': 'default.png',
        'tipo_documento': _selectedTipoDocumento,
      };

      // Llamar al servicio de registro
      final success = await AuthService.register(userData, context);

      if (success) {
        // El registro fue exitoso y la navegación se maneja en AuthService
        return;
      }
    } catch (e) {
      String errorMessage = 'Error en el registro';

      if (e.toString().contains('duplicate')) {
        errorMessage = 'El email o documento ya está registrado';
      } else if (e.toString().contains('connection')) {
        errorMessage = 'Error de conexión. Verifica tu internet';
      } else if (e.toString().contains('timeout')) {
        errorMessage = 'Tiempo de espera agotado. Intenta nuevamente';
      } else {
        errorMessage = 'Error en el registro: $e';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Logo de BioHub
              Image.asset('assets/img/logo.png', width: 60, height: 60),
              const SizedBox(height: 16),
              const Text(
                'BioHub',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 20),
              // Tabs
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xFF2E7D32),
                              width: 3,
                            ),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Registrarse',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: Container(
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              'Iniciar Sesión',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF2E7D32),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dropdown Discapacidad
                      _buildDropdown(
                        'Discapacidad',
                        [
                          'Ninguna',
                          'Física',
                          'Visual',
                          'Auditiva',
                          'Cognitiva',
                        ],
                        _selectedDiscapacidad,
                        (value) {
                          setState(() {
                            _selectedDiscapacidad = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Dropdown Etnia
                      _buildDropdown(
                        'Etnia',
                        [
                          'No Aplica',
                          'Indígena',
                          'Afrodescendiente',
                          'Rom',
                          'Raizal',
                          'Palenquero',
                        ],
                        _selectedEtnia,
                        (value) {
                          setState(() {
                            _selectedEtnia = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Dropdown Género
                      _buildDropdown(
                        'Género',
                        [
                          'Masculino',
                          'Femenino',
                          'No Binario',
                          'Prefiero no decir',
                        ],
                        _selectedGenero,
                        (value) {
                          setState(() {
                            _selectedGenero = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Dropdown Tipo de Documento
                      _buildDropdown(
                        'Tipo de Documento',
                        [
                          'Cédula de Ciudadanía',
                          'Tarjeta de Identidad',
                          'Cédula de Extranjería',
                          'Pasaporte',
                        ],
                        _selectedTipoDocumento,
                        (value) {
                          setState(() {
                            _selectedTipoDocumento = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Campo Documento
                      _buildTextField('Documento', _documentoController),
                      const SizedBox(height: 20),

                      // Área de carga de imagen
                      const Text(
                        'Foto de Perfil',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Icon(
                                  Icons.landscape,
                                  size: 40,
                                  color: Colors.grey.shade400,
                                ),
                                Positioned(
                                  top: -5,
                                  right: -5,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2E7D32),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '(Tamaño Máximo 500kb)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Botón de registro
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE8F5E8),
                            foregroundColor: const Color(0xFF2E7D32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                          ),
                          child:
                              _isLoading
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFF2E7D32),
                                      ),
                                    ),
                                  )
                                  : const Text(
                                    'Registrarse',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
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
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> options,
    String? value,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            initialValue: value,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            items:
                options.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
            onChanged: onChanged,
            hint: const Text('Seleccionar'),
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
