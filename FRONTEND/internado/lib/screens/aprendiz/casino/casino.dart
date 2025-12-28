import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CasinoPage extends StatefulWidget {
  const CasinoPage({super.key});

  @override
  State<CasinoPage> createState() => _CasinoPageState();
}

class _CasinoPageState extends State<CasinoPage> {
  // Guardar comidas reclamadas
  final Map<String, bool> _reclamado = {
    "Desayuno": false,
    "Almuerzo": false,
    "Cena": false,
  };

  // Obtener la comida disponible según hora
  String? _comidaDisponible() {
    final now = DateTime.now();
    final hora = now.hour;

    if (hora >= 6 && hora < 10) return "Desayuno";
    if (hora >= 12 && hora < 16) return "Almuerzo";
    if (hora >= 18 && hora < 20) return "Cena";
    return null; // fuera de horario
  }

  void _mostrarQR(BuildContext context, String comida) {
    if (_reclamado[comida] == true) return; // ya reclamado
    setState(() {
      _reclamado[comida] = true; // marcar como reclamado
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QRPage(comida: comida)),
    );
  }

  Widget _buildBoton(String comida, Color color) {
    final disponible = _comidaDisponible();
    final yaReclamado = _reclamado[comida] ?? false;

    // Si no está en horario, botón apagado
    final habilitado = disponible == comida && !yaReclamado;

    return SizedBox(
      width: double.infinity, // 🔹 ocupa todo el ancho (uniforme)
      child: ElevatedButton(
        onPressed: habilitado ? () => _mostrarQR(context, comida) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              yaReclamado
                  ? Colors.red[600] // ya reclamado
                  : habilitado
                  ? color
                  : Colors.grey[400], // fuera de horario
          padding: const EdgeInsets.symmetric(vertical: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          elevation: 5,
        ),
        child: Text(
          yaReclamado ? "Ya recibiste tu $comida ✅" : comida,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final disponible = _comidaDisponible();

    return Scaffold(
      backgroundColor: const Color(0xFFF6FBE4),
      appBar: AppBar(
        title: const Text("Casino"),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              disponible == null
                  ? "No hay comidas disponibles en este horario ⏰"
                  : "Disponible ahora: $disponible 🍽️",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildBoton("Desayuno", Colors.orange[300]!),
            const SizedBox(height: 25),
            _buildBoton("Almuerzo", Colors.green[400]!),
            const SizedBox(height: 25),
            _buildBoton("Cena", Colors.yellow[700]!),
          ],
        ),
      ),
    );
  }
}

class QRPage extends StatelessWidget {
  final String comida;

  const QRPage({super.key, required this.comida});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR - $comida"),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF6FBE4),
      body: Center(
        child: QrImageView(
          data: "Usuario123 - $comida - ${DateTime.now()}",
          version: QrVersions.auto,
          size: 280.0,
          eyeStyle: const QrEyeStyle(
            eyeShape: QrEyeShape.square,
            color: Colors.black,
          ),
          dataModuleStyle: const QrDataModuleStyle(
            dataModuleShape: QrDataModuleShape.circle,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
