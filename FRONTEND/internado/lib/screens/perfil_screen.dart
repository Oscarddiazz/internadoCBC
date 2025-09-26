import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = false;
  Map<String, dynamic>? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final res = await ApiService.getProfile();
      if (res['success'] == true) {
        setState(() {
          _userProfile = res['data'];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar perfil: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header section with cream background
            Container(
              color: const Color(0xFFF5F5DC), // cream color
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
              child: Column(
                children: [
                  // Back arrow
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.chevron_left,
                        size: 32,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Profile photo placeholder with camera icon
                  Stack(
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E5E5), // gray color
                          shape: BoxShape.circle,
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // User information section
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Name
                  _buildInfoItem(
                    icon: Icons.person,
                    label: "Nombre y Apellidos:",
                    value: _userProfile != null 
                        ? "${_userProfile!['user_name']} ${_userProfile!['user_ape']}"
                        : "Cargando...",
                  ),
                  const SizedBox(height: 32),
                  // Email
                  _buildInfoItem(
                    icon: Icons.mail,
                    label: "Email:",
                    value: _userProfile?['user_email'] ?? "Cargando...",
                  ),
                  const SizedBox(height: 32),
                  // Phone
                  _buildInfoItem(
                    icon: Icons.phone,
                    label: "Telefono:",
                    value: _userProfile?['user_tel'] ?? "Cargando...",
                  ),
                  const SizedBox(height: 32),
                  // Password
                  _buildInfoItem(
                    icon: Icons.lock,
                    label: "Password:",
                    value: "****************",
                    isPassword: true,
                  ),
                ],
              ),
            ),
            // Edit button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    // Handle edit action
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Editar Informacion",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    bool isPassword = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon container
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(
              icon == Icons.person
                  ? 24
                  : 8, // Circle for person, rounded square for others
            ),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 16),
        // Text content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  height: 1.2,
                  letterSpacing: isPassword ? 2.0 : 0.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
