import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/constants/role_config.dart';
import 'package:heraguard_frontend/core/injection/container.dart';
import 'package:heraguard_frontend/core/models/user_role.dart';
import 'package:heraguard_frontend/core/providers/app_provider.dart';
import 'package:heraguard_frontend/core/providers/auth_provider.dart';
import 'package:heraguard_frontend/core/routes/app_routes.dart';
import 'package:heraguard_frontend/core/storage/secure_storage.dart';
import 'package:heraguard_frontend/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:provider/provider.dart';

class RouteUtils {
  static void goToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  static void goToRegister(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.register);
  }

  static Future<void> logout(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    final appProvider = context.read<AppProvider>();
    try {
      final authRepository = AuthRepositoryImpl(sl<SecureStorage>());
      await authRepository.logout();
    } catch (e) {
      print("Error en logout backend: $e");
    } finally {
      appProvider.setNavIndex(0);
      authProvider.logout();
    }
    if (context.mounted) {
      goToLogin(context);
    }
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

  static void navigateToRoute(
    BuildContext context,
    String routeName,
    String userRole,
  ) {
    final routes = RoleConfig.getRoutesForRole(userRole);
    final route = routes.firstWhere((r) => r.name == routeName);
    Navigator.pushNamed(context, route.path);
  }
}
