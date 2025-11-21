import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:heraguard_frontend/core/providers/auth_provider.dart';
import 'package:heraguard_frontend/core/routes/route_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSession();
    });
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    final authProvider = context.read<AuthProvider>();
    await authProvider.loadSession();

    if (!mounted) return;

    if (authProvider.token != null) {
      RouteUtils.goToHomeByRole(context, authProvider.userRole ?? "");
    } else {
      RouteUtils.goToLogin(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Image(
              image: AssetImage(
                'assets/images/logo.webp',
              ),
              width: 150,
              height: 150,
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Cargando..."),
          ],
        ),
      ),
    );
  }
}
