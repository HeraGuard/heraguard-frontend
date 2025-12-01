import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heraguard_frontend/core/routes/app_routes.dart';
import 'package:heraguard_frontend/features/MedicalAppointments/presentation/screens/add_medical_appointment.dart';
import 'package:heraguard_frontend/features/activities/presentation/screens/add_activity.dart';
import 'package:heraguard_frontend/features/auth/presentation/screens/login_screen.dart';
import 'package:heraguard_frontend/features/auth/presentation/screens/register_screen.dart';
import 'package:heraguard_frontend/features/auth/presentation/screens/splash_screen.dart';
import 'package:heraguard_frontend/features/caregiver/presentation/screens/caregiver_home.dart';
import 'package:heraguard_frontend/features/caregiver/presentation/screens/sos_alert_screen.dart';
import 'package:heraguard_frontend/features/doctor/presentation/screens/doctor_chats.dart';
import 'package:heraguard_frontend/features/doctor/presentation/screens/doctor_home.dart';
import 'package:heraguard_frontend/features/doctor/presentation/screens/doctor_notifications.dart';
import 'package:heraguard_frontend/features/doctor/presentation/screens/doctor_settings.dart';
import 'package:heraguard_frontend/features/elder/presentation/screens/elder_alert.dart';
import 'package:heraguard_frontend/features/elder/presentation/screens/elder_chats.dart';
import 'package:heraguard_frontend/features/elder/presentation/screens/elder_home.dart';
import 'package:heraguard_frontend/features/elder/presentation/screens/elder_notifications.dart';
import 'package:heraguard_frontend/features/elder/presentation/screens/elder_profile.dart';
import 'package:heraguard_frontend/features/elder/presentation/screens/elder_settings.dart';
import 'package:heraguard_frontend/features/elder/presentation/screens/add_elder.dart';
import 'package:heraguard_frontend/features/elder/presentation/screens/elder_list.dart';
import 'package:heraguard_frontend/features/medication_history/presentation/screens/medication_history_screen.dart';
import 'package:heraguard_frontend/features/medications/data/repositories/medication_repository_impl.dart';
import 'package:heraguard_frontend/features/medications/presentation/bloc/medication_intake_bloc.dart';
import 'package:heraguard_frontend/features/medications/presentation/screens/add_medication.dart';
import 'package:heraguard_frontend/features/medications/presentation/screens/medication_intake_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case AppRoutes.elderHome:
        return MaterialPageRoute(builder: (_) => const ElderHome());
      case AppRoutes.elderChats:
        return MaterialPageRoute(builder: (_) => const ElderChats());
      case AppRoutes.elderNotifications:
        return MaterialPageRoute(builder: (_) => const ElderNotifications());
      case AppRoutes.elderAlert:
        return MaterialPageRoute(builder: (_) => const ElderAlert());
      case AppRoutes.elderSettings:
        return MaterialPageRoute(builder: (_) => const ElderSettings());
      case AppRoutes.caregiverHome:
        return MaterialPageRoute(builder: (_) => const CaregiverHome());
      case AppRoutes.doctorHome:
        return MaterialPageRoute(builder: (_) => const DoctorHome());
      case AppRoutes.doctorChats:
        return MaterialPageRoute(builder: (_) => const DoctorChats());
      case AppRoutes.doctorNotifications:
        return MaterialPageRoute(builder: (_) => const DoctorNotifications());
      case AppRoutes.doctorSettings:
        return MaterialPageRoute(builder: (_) => const DoctorSettings());
      case AppRoutes.elderList:
        return MaterialPageRoute(builder: (_) => const ElderList());
      case AppRoutes.addElder:
        return MaterialPageRoute(builder: (_) => const AddElder());
      case AppRoutes.addMedication:
        return MaterialPageRoute(builder: (_) => const AddMedicationScreen());
      case AppRoutes.addActivity:
        return MaterialPageRoute(builder: (_) => const AddActivityScreen());
      case AppRoutes.addMedicalAppointment:
        return MaterialPageRoute(builder: (_) => const AddMedicalAppointment());
      case AppRoutes.medicationHistory:
        return MaterialPageRoute(
          builder: (_) => const MedicationHistoryScreen(),
          settings: settings,
        );
      case AppRoutes.elderProfile:
        return MaterialPageRoute(builder: (_) => const ElderProfile());
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.medicationIntake:
        final intakeId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) {
            final repository = RepositoryProvider.of<MedicationRepositoryImpl>(
              context,
            );
            return BlocProvider(
              create: (_) =>
                  MedicationIntakeBloc(repository: repository)
                    ..add(LoadIntake(intakeId)),
              child: MedicationIntakeScreen(intakeId: intakeId),
            );
          },
          settings: settings,
        );
      case AppRoutes.sosAlert:
        final args = settings.arguments as Map<String, dynamic>;
        final elderId = args['elderId'] as String? ?? '';
        final sosId = args['sosId'] as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => SosAlertScreen(elderId: elderId, sosId: sosId),
          settings: settings,
        );
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
