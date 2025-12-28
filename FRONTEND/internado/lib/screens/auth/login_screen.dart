import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _obscurePassword = true;
  bool _isLoading = false;
  final bool _isNavigating = false;

  // Controladores
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Para registro
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();

  String? _selectedRol;
  bool _aceptarTerminos = false;

  final List<String> _roles = ['Administrador', 'Delegado', 'Aprendiz'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nombreController.dispose();
    _apellidosController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService.login(
        _emailController.text.trim(),
        _passwordController.text,
        context,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _mostrarTerminos() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Términos y Condiciones"),
          content: const SingleChildScrollView(
            child: Text(
              "Al registrarte, aceptas nuestros términos y condiciones de uso.",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cerrar"),
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

    final hasUpper = password.contains(RegExp(r'[A-Z]'));
    final hasLower = password.contains(RegExp(r'[a-z]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));

    if (!hasUpper || !hasLower || !hasNumber) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'La contraseña debe contener mayúscula, minúscula y número',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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
              const SizedBox(height: 40),
              Image.asset("assets/img/logo.png", width: 80, height: 80),
              const SizedBox(height: 20),
              const Text(
                "BioHub",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: const Color(0xFF2E7D32),
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: const Color(0xFF2E7D32),
                  indicatorWeight: 3,
                  tabs: const [
                    Tab(text: "Registrarse"),
                    Tab(text: "Iniciar Sesión"),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [_buildRegisterTab(), _buildLoginTab()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- LOGIN ----------------
  Widget _buildLoginTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField("Email", controller: _emailController),
        const SizedBox(height: 20),
        _buildPasswordField("Contraseña", _passwordController),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () {},
            child: const Text(
              "¿Olvidaste tu contraseña?",
              style: TextStyle(color: Color(0xFF2E7D32), fontSize: 14),
            ),
          ),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleLogin,
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
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF2E7D32),
                        ),
                      ),
                    )
                    : const Text(
                      "Iniciar Sesión",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
          ),
        ),
      ],
    );
  }

  // ---------------- REGISTER ----------------
  Widget _buildRegisterTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField("Nombre", controller: _nombreController),
          const SizedBox(height: 16),
          _buildTextField("Apellidos", controller: _apellidosController),
          const SizedBox(height: 16),
          _buildTextField("Email", controller: _emailController),
          const SizedBox(height: 16),
          _buildTextField("Teléfono", controller: _telefonoController),
          const SizedBox(height: 16),
          _buildPasswordField("Contraseña", _passwordController),
          const SizedBox(height: 16),
          _buildDropdown("Rol", _roles, _selectedRol, (value) {
            setState(() => _selectedRol = value);
          }),
          const SizedBox(height: 16),
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
                  "Mínimo 8 caracteres, incluir mayúscula, minúscula y número",
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Checkbox(
                value: _aceptarTerminos,
                onChanged:
                    (value) =>
                        setState(() => _aceptarTerminos = value ?? false),
                activeColor: const Color(0xFF2E7D32),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: _mostrarTerminos,
                  child: const Text(
                    "Aceptar Términos y Condiciones",
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
                "Siguiente",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- HELPERS ----------------
  Widget _buildTextField(
    String label, {
    TextEditingController? controller,
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
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.black87,
              ),
              onPressed:
                  () => setState(() => _obscurePassword = !_obscurePassword),
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
                options
                    .map(
                      (option) =>
                          DropdownMenuItem(value: option, child: Text(option)),
                    )
                    .toList(),
            onChanged: onChanged,
            hint: const Text("Seleccionar"),
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
