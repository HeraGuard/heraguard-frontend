import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/extensions/auth_context.dart';
import 'package:heraguard_frontend/core/widgets/appbar_widget.dart';
import 'package:heraguard_frontend/core/widgets/card_home.dart';

class DoctorHome extends StatelessWidget {
  const DoctorHome({super.key});

  @override
  Widget build(BuildContext context) {
    //final authData = context.authData;
    final userRole = context.userRole;
    print('Rol del usuario: ${userRole.role}');
    print('Rutas:');
    for (final route in userRole.routes) {
      print('${route.name} -> ${route.path}');
    }
    return Scaffold(
      appBar: AppbarWidget(title: "HeraGuard"),
      body: Column(
        children: [
          CardHome(
            title: 'Agendar Cita',
            imagePath: 'assets/images/cita_medica.jpg',
            onTap: () {},
          ),
          const SizedBox(height: 10),
          CardHome(
            title: 'Recetar Medicamento',
            imagePath: 'assets/images/tomar_medicamento.jpg',
            onTap: () {},
          ),
          const SizedBox(height: 10),
          CardHome(
            title: 'Programar Actividad',
            imagePath: 'assets/images/actividad.png',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
