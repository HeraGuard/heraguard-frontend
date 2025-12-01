import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heraguard_frontend/core/injection/container.dart';
import 'package:heraguard_frontend/core/network/api_client.dart';
import 'package:heraguard_frontend/core/providers/app_provider.dart';
import 'package:heraguard_frontend/core/providers/auth_provider.dart';
import 'package:heraguard_frontend/core/routes/app_routes.dart';
import 'package:heraguard_frontend/core/routes/route_generator.dart';
import 'package:heraguard_frontend/core/services/notification_service.dart';
import 'package:heraguard_frontend/core/storage/secure_storage.dart';
import 'package:heraguard_frontend/features/elder/domain/repositories/elder_repository.dart';
import 'package:heraguard_frontend/features/medications/data/datasources/medication_local_data_source.dart';
import 'package:heraguard_frontend/features/medications/data/repositories/medication_repository_impl.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().initialize();
  await InjectionContainer.initialize();
  runApp(const AppProviders());
}

class AppProviders extends StatelessWidget {
  const AppProviders({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(sl<SecureStorage>()),
        ),
        ChangeNotifierProvider(create: (_) => AppProvider()),
        RepositoryProvider<MedicationRepositoryImpl>(
          create: (_) => MedicationRepositoryImpl(
            localDataSource: MedicationLocalDataSource(),
            apiClient: ApiClient(),
          ),
        ),
        RepositoryProvider<ElderRepository>(
          create: (_) => sl<ElderRepository>(),
        ),
      ],
      child: const HeraGuard(),
    );
  }
}

class HeraGuard extends StatelessWidget {
  const HeraGuard({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.blue,
        //scaffoldBackgroundColor: const Color(0xFFD4EDF8),
        //appBarTheme: const Color(0xFFD4EDF8),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
