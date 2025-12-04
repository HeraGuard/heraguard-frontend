import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/routes/route_utils.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => RouteUtils.logout(context),
      backgroundColor: Colors.red,
      icon: const Icon(Icons.logout, color: Colors.white),
      label: const Text('Cerrar Sesión', style: TextStyle(color: Colors.white)),
    );
  }
}
