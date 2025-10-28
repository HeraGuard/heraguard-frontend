import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/routes/app_routes.dart';
import 'package:heraguard_frontend/features/auth/presentation/screens/login_screen.dart';
import 'package:heraguard_frontend/features/auth/presentation/screens/register_screen.dart';
import 'package:heraguard_frontend/features/caregiver/presentation/screens/caregiver_home.dart';
import 'package:heraguard_frontend/features/doctor/presentation/screens/doctor_home.dart';
import 'package:heraguard_frontend/features/elder/presentation/screens/elder_home.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case AppRoutes.elderHome:
        return MaterialPageRoute(builder: (_) => const ElderHome());
      case AppRoutes.caregiverHome:
        return MaterialPageRoute(builder: (_) => const CaregiverHome());
      case AppRoutes.doctorHome:
        return MaterialPageRoute(builder: (_) => const DoctorHome());
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
