import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/routes/app_routes.dart';
import 'package:heraguard_frontend/core/widgets/card_home.dart';

class CaregiverHome extends StatelessWidget {
  const CaregiverHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hera Guard')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardHome(
              title: 'Añadir familiar',
              imagePath: 'assets/images/agregar_familiar.jpg',
              onTap: () {},
            ),
            const SizedBox(height: 16),
            CardHome(
              title: 'Añadir medicamento',
              imagePath: 'assets/images/tomar_medicamento.jpg',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.addMedication);
              },
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
      ),
    );
  }
}
