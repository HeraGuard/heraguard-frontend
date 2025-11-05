import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/widgets/navbar_bottom.dart';

class DoctorPatients extends StatelessWidget {
  const DoctorPatients({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Doctor Pacientes')],
        ),
      ),
      bottomNavigationBar: NavbarBottom(),
    );
  }
}
