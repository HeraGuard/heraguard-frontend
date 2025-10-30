import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/widgets/card_home.dart';

class CaregiverHome extends StatelessWidget {
  const CaregiverHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hera Guard')),
      body: Column(
        children: [
          CardHome(
            title: 'Añadir familiar',
            imagePath: 'assets/images/agregar_familiar.jpg',
            onTap: () {},
          ),
          const SizedBox(height: 16),
          CardHome(
            title: 'Mensaje rapido',
            imagePath: 'assets/images/mensaje_rapido_op2.jpg',
            onTap: () {},
          ),
          const SizedBox(height: 16),
          CardHome(
            title: 'Historial alexa',
            imagePath: 'assets/images/historial_asistent_voz.jpg',
            onTap: () {},
          ),
          const SizedBox(height: 16),
          CardHome(
            title: 'Historial medicamentos',
            imagePath: 'assets/images/historial_medicamentos.jpg',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
