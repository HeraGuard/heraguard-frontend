import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/constants/role_config.dart';
import 'package:heraguard_frontend/core/models/user_role.dart';
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
    Navigator.pushReplacementNamed(context, AppRoutes.register);
  }

  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  static void goToHomeByRole(BuildContext context, String role) {
    final homeRoute = RoleConfig.getHomeRoute(role);
    Navigator.pushNamedAndRemoveUntil(context, homeRoute, (route) => false);
  }

  static List<AppRoute> getRoutesForRole(String role) {
    return RoleConfig.getRoutesForRole(role);
  }
}
