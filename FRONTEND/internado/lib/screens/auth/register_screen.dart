import 'package:flutter/material.dart';
import '../../utils/terminos_condiciones.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _selectedRol;
  bool _aceptarTerminos = false;
  bool _obscurePassword = true;

  // Roles según la base de datos
  final List<String> _roles = ['Administrador', 'Delegado', 'Aprendiz'];

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidosController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _mostrarTerminos() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(TerminosCondiciones.titulo),
          content: SingleChildScrollView(
            child: Text(TerminosCondiciones.contenido),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _siguiente() {
    if (_nombreController.text.isEmpty ||
        _apellidosController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _telefonoController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _selectedRol == null ||
        !_aceptarTerminos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor completa todos los campos y acepta los términos y condiciones',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Validar contraseña
    final password = _passwordController.text;
    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La contraseña debe tener al menos 8 caracteres'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validar que la contraseña contenga al menos una mayúscula, una minúscula y un número
    final hasUpperCase = password.contains(RegExp(r'[A-Z]'));
    final hasLowerCase = password.contains(RegExp(r'[a-z]'));
    final hasNumbers = password.contains(RegExp(r'[0-9]'));

    if (!hasUpperCase || !hasLowerCase || !hasNumbers) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'La contraseña debe contener al menos una mayúscula, una minúscula y un número',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Navegar al siguiente paso
    Navigator.pushNamed(
      context,
      '/register-step2',
      arguments: {
        'nombre': _nombreController.text,
        'apellidos': _apellidosController.text,
        'email': _emailController.text,
        'telefono': _telefonoController.text,
        'password': _passwordController.text,
        'rol': _selectedRol,
      },
    );
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
                      // Campo Nombre
                      _buildTextField('Nombre', _nombreController),
                      const SizedBox(height: 16),

                      // Campo Apellidos
                      _buildTextField('Apellidos', _apellidosController),
                      const SizedBox(height: 16),

                      // Campo Email
                      _buildTextField(
                        'Email',
                        _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),

                      // Campo Teléfono
                      _buildTextField(
                        'Teléfono',
                        _telefonoController,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),

                      // Campo Contraseña
                      _buildPasswordField('Contraseña', _passwordController),
                      const SizedBox(height: 16),

                      // Dropdown Rol
                      _buildDropdown('Rol', _roles, _selectedRol, (value) {
                        setState(() {
                          _selectedRol = value;
                        });
                      }),
                      const SizedBox(height: 16),

                      // Requisitos de contraseña
                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF2E7D32),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Mínimo 8 caracteres, contener mayúsculas y minúsculas, número o carácter especial',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Checkbox términos y condiciones
                      Row(
                        children: [
                          Checkbox(
                            value: _aceptarTerminos,
                            onChanged: (value) {
                              setState(() {
                                _aceptarTerminos = value ?? false;
                              });
                            },
                            activeColor: const Color(0xFF2E7D32),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: _mostrarTerminos,
                              child: const Text(
                                'Aceptar Términos y Condiciones',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF2E7D32),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Botón Siguiente
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _siguiente,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE8F5E8),
                            foregroundColor: const Color(0xFF2E7D32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Siguiente',
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

  Widget _buildPasswordField(String label, TextEditingController controller) {
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
          obscureText: _obscurePassword,
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
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: Colors.black87,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
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
            value: value,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            items: options.map((String option) {
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
