import 'package:flutter/material.dart';

class Utils {
  // Mostrar snackbar
  static void showSnackBar(
    BuildContext context,
    String message, {
    Color? color,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color ?? Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Mostrar diálogo de confirmación
  static Future<bool> showConfirmDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Confirmar'),
              ),
            ],
          ),
    );
    return result ?? false;
  }

  // Mostrar loading
  static void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  // Ocultar loading
  static void hideLoading(BuildContext context) {
    Navigator.of(context).pop();
  }
}
