import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/routes/app_routes.dart';
import 'package:heraguard_frontend/core/widgets/appbar_widget.dart';
import 'package:heraguard_frontend/core/widgets/card_home.dart';
import 'package:heraguard_frontend/core/widgets/navbar_bottom.dart';

class DoctorHome extends StatelessWidget {
  const DoctorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(title: "HeraGuard"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            CardHome(
              title: 'Agendar Cita',
              imagePath: 'assets/images/cita_medica.jpg',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.addMedicalAppointment);
              },
            ),
            const SizedBox(height: 10),
            CardHome(
              title: 'Recetar Medicamento',
              imagePath: 'assets/images/tomar_medicamento.jpg',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.addMedication);
              },
            ),
            const SizedBox(height: 10),
            CardHome(
              title: 'Programar Actividad',
              imagePath: 'assets/images/actividad.png',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.addActivity);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavbarBottom(),
    );
  }
}
