import 'package:flutter/material.dart';

class CasinoNumberPad extends StatefulWidget {
  const CasinoNumberPad({Key? key}) : super(key: key);

  @override
  State<CasinoNumberPad> createState() => _CasinoNumberPadState();
}

class _CasinoNumberPadState extends State<CasinoNumberPad> {
  String cedulaNumber = '';

  void handleNumberClick(int num) {
    setState(() {
      if (cedulaNumber.length < 10) {
        // Limitamos a 10 dígitos
        cedulaNumber += num.toString();
      }
    });
  }

  void borrarUltimoNumero() {
    setState(() {
      if (cedulaNumber.isNotEmpty) {
        cedulaNumber = cedulaNumber.substring(0, cedulaNumber.length - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9];

    return Scaffold(
      backgroundColor: const Color(0xFFF6FBE4),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.chevron_left, size: 32, weight: 3),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const Text(
                    'Casino',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
            // Main Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
                child: Column(
                  children: [
                    // Display Card
                    Container(
                      height: 112,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              cedulaNumber,
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF277400),
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          if (cedulaNumber.isNotEmpty)
                            Positioned(
                              right: 16,
                              top: 16,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.backspace_outlined,
                                  color: Color(0xFF277400),
                                  size: 28,
                                ),
                                onPressed: borrarUltimoNumero,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Number Grid
                    Expanded(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 448),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 24,
                                  mainAxisSpacing: 24,
                                  childAspectRatio: 1,
                                ),
                            itemCount: numbers.length,
                            itemBuilder: (context, index) {
                              final num = numbers[index];
                              return GestureDetector(
                                onTapDown: (_) {
                                  setState(() {});
                                },
                                onTapUp: (_) {
                                  handleNumberClick(num);
                                },
                                onTapCancel: () {
                                  setState(() {});
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD9D9D9),
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      num.toString(),
                                      style: const TextStyle(
                                        fontSize: 60,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF277400),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Consultar Button
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 448),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                cedulaNumber.isEmpty
                                    ? null
                                    : () {
                                      // Aquí irá la lógica de consulta
                                      print(
                                        'Consultando cédula: $cedulaNumber',
                                      );
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF39A900),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 48,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              elevation: 8,
                              shadowColor: Colors.black.withOpacity(0.3),
                            ),
                            child: const Text(
                              'Consultar',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
    );
  }
}
