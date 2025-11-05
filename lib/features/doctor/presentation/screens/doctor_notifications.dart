import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/widgets/navbar_bottom.dart';

class DoctorNotifications extends StatelessWidget {
  const DoctorNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Doctor Notificaciones')],
        ),
      ),
      bottomNavigationBar: NavbarBottom(),
    );
  }
}
