import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/providers/auth_provider.dart';
import 'package:heraguard_frontend/core/routes/app_routes.dart';
import 'package:heraguard_frontend/core/routes/route_generator.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const AppProvider());
}

class AppProvider extends StatelessWidget {
  const AppProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
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
