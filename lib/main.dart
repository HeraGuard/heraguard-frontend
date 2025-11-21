import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/injection/container.dart';
import 'package:heraguard_frontend/core/providers/app_provider.dart';
import 'package:heraguard_frontend/core/providers/auth_provider.dart';
import 'package:heraguard_frontend/core/routes/app_routes.dart';
import 'package:heraguard_frontend/core/routes/route_generator.dart';
import 'package:heraguard_frontend/core/services/notification_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InjectionContainer.initialize();
  runApp(const AppProviders());
  await NotificationService().initialize();
}

class AppProviders extends StatelessWidget {
  const AppProviders({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
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
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color(0xFF0040FF),
        //scaffoldBackgroundColor: const Color(0xFFD4EDF8),
        //appBarTheme: const Color(0xFFD4EDF8),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
