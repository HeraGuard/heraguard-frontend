// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/routes/route_utils.dart';
import 'package:heraguard_frontend/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:heraguard_frontend/features/auth/presentation/widgets/auth_header.dart';
import 'package:heraguard_frontend/features/auth/presentation/widgets/login_form.dart';
import 'package:heraguard_frontend/features/auth/presentation/widgets/auth_link.dart';
import 'package:heraguard_frontend/features/auth/presentation/widgets/auth_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthRepositoryImpl _authRepo = AuthRepositoryImpl();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _emailError = 'El email es requerido';
      } else if (!value.contains('@')) {
        _emailError = 'Formato de email inválido';
      } else {
        _emailError = null;
      }
    });
  }

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _passwordError = 'La contraseña es requerida';
      } else if (value.length < 6) {
        _passwordError = 'Mínimo 6 caracteres';
      } else {
        _passwordError = null;
      }
    });
  }

  bool _formLoginValido() {
    return _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _emailError == null &&
        _passwordError == null;
  }

  void _navigateToRegister() {
    RouteUtils.goToRegister(context);
  }

  void _submitForm() async {
    setState(() => _isLoading = true);

    try {
      final response = await _authRepo.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '¡Bienvenido ${response.user.name}!',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

      RouteUtils.goToHomeByRole(context, response.user.role);

      _emailController.clear();
      _passwordController.clear();
    } catch (e) {
      _handleError(e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleError(dynamic error) {
    String errorMessage = 'Error desconocido';

    if (error is DioException) {
      final response = error.response;

      if (response != null && response.data is Map) {
        final data = response.data as Map<String, dynamic>;
        errorMessage = data['message'] ?? 'Error sin mensaje';
        if (errorMessage.contains('credenciales') ||
            errorMessage.contains('invalid credentials')) {
          errorMessage = 'Email o contraseña incorrectos';
        } else if (errorMessage.contains('email')) {
          errorMessage = 'Formato de email inválido';
        } else if (errorMessage.contains('password')) {
          errorMessage = 'Contraseña inválida';
        }
        //   case 429:
        //     errorMessage = 'Demasiados intentos. Intenta más tarde';
        //     break;
      } else {
        errorMessage = 'Error de conexión';
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _onForgotPassword() {
    print('Olvidé contraseña');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const AuthHeader(
                  icon: Icons.health_and_safety,
                  title: "Bienvenido a HeraGuard",
                  subtitle: "Tu asistente de salud personal",
                ),

                const SizedBox(height: 20),

                LoginForm(
                  emailController: _emailController,
                  passwordController: _passwordController,
                  obscurePassword: _obscurePassword,
                  rememberMe: _rememberMe,
                  onObscurePasswordChanged: (value) {
                    setState(() => _obscurePassword = value);
                  },
                  onRememberMeChanged: (value) {
                    setState(() => _rememberMe = value);
                  },
                  onForgotPassword: _onForgotPassword,
                  onEmailChanged: _validateEmail,
                  onPasswordChanged: _validatePassword,
                  emailError: _emailError,
                  passwordError: _passwordError,
                ),

                const SizedBox(height: 20),

                AuthButton(
                  title: "Iniciar Sesión",
                  isLoading: _isLoading,
                  isEnabled: _formLoginValido(),
                  onPressed: _submitForm,
                ),

                const SizedBox(height: 24),

                AuthLink(
                  onTap: _navigateToRegister,
                  title: "¿No tienes cuenta? ",
                  titleLink: "Regístrate",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
