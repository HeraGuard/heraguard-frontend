import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/routes/app_routes.dart';

class SosAlertScreen extends StatelessWidget {
  final String elderId;
  final String sosId;

  const SosAlertScreen({required this.elderId, required this.sosId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade900,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning, size: 80, color: Colors.white),
              const SizedBox(height: 16),
              const Text(
                'ALERTA SOS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'El adulto mayor ha pedido ayuda.\nRevisa su estado de inmediato.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                ),
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pushReplacementNamed(AppRoutes.caregiverHome);
                },
                child: const Text('Aceptar alerta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
