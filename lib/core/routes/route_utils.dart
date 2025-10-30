import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/routes/app_routes.dart';

class RouteUtils {
  static void goToLogin(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  static void goToRegister(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.register);
  }

  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  // Navegación por rol
  static void goToHomeByRole(BuildContext context, String role) {
    goToLogin(context);
  }
}
