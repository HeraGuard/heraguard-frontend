// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:heraguard_frontend/core/routes/route_utils.dart';
import 'package:heraguard_frontend/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:heraguard_frontend/features/auth/presentation/widgets/auth_link.dart';
import 'package:heraguard_frontend/features/auth/presentation/widgets/auth_header.dart';
import 'package:heraguard_frontend/features/auth/presentation/widgets/register_form.dart';
import 'package:heraguard_frontend/features/auth/presentation/widgets/auth_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthRepositoryImpl _authRepo = AuthRepositoryImpl();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _selectedRole;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
      if (_confirmPasswordController.text.isNotEmpty) {
        _validateConfirmPassword(_confirmPasswordController.text);
      }
    });
  }

  void _validateConfirmPassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _confirmPasswordError = 'Confirma tu contraseña';
      } else if (value != _passwordController.text) {
        _confirmPasswordError = 'Las contraseñas no coinciden';
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  bool _formRegisterValido() {
    return _nameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _selectedRole != null &&
        _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null;
  }

  void _navigateToLogin() {
    RouteUtils.goBack(context);
  }

  void _submitForm() async {
    setState(() => _isLoading = true);

    try {
      final response = await _authRepo.register(
        _nameController.text.trim(),
        _lastNameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _selectedRole!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '¡Cuenta creada para ${response.user.name}!',
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

      _nameController.clear();
      _lastNameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
    } catch (e) {
      _handleError(e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleError(dynamic error) {
    String errorMessage = 'Error al crear cuenta';

    if (error is DioException) {
      final response = error.response;

      if (response != null && response.data is Map) {
        final data = response.data as Map<String, dynamic>;
        errorMessage = data['message'] ?? 'Error al crear cuenta';

        switch (response.statusCode) {
          case 400:
            if (errorMessage.contains('email') &&
                errorMessage.contains('exists')) {
              errorMessage = 'El email ya está registrado';
            } else if (errorMessage.contains('email')) {
              errorMessage = 'Formato de email inválido';
            } else if (errorMessage.contains('password') &&
                errorMessage.contains('weak')) {
              errorMessage = 'La contraseña debe tener al menos 6 caracteres';
            } else if (errorMessage.contains('name') ||
                errorMessage.contains('lastname')) {
              errorMessage = 'Nombre y apellido son requeridos';
            } else if (errorMessage.contains('role')) {
              errorMessage = 'Selecciona un rol válido';
            }
            break;
          case 409:
            errorMessage = 'El usuario ya existe';
            break;
        }
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
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
                  icon: Icons.person_add_alt_1,
                  title: "Únete a nosotros",
                  subtitle: "Crea tu cuenta para comenzar",
                ),

                const SizedBox(height: 20),

                RegisterForm(
                  nameController: _nameController,
                  lastNameController: _lastNameController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController,
                  obscurePassword: _obscurePassword,
                  obscureConfirmPassword: _obscureConfirmPassword,
                  selectedRole: _selectedRole,
                  onObscurePasswordChanged: (value) {
                    setState(() => _obscurePassword = value);
                  },
                  onObscureConfirmPasswordChanged: (value) {
                    setState(() => _obscureConfirmPassword = value);
                  },
                  onRoleChanged: (value) {
                    setState(() => _selectedRole = value);
                  },
                  onNameChanged: (value) => setState(() {}),
                  onLastNameChanged: (value) => setState(() {}),
                  onPasswordChanged: _validatePassword,
                  onConfirmPasswordChanged: _validateConfirmPassword,
                  emailError: _emailError,
                  passwordError: _passwordError,
                  confirmPasswordError: _confirmPasswordError,
                ),

                const SizedBox(height: 20),

                AuthButton(
                  title: "Crear Cuenta",
                  isLoading: _isLoading,
                  isEnabled: _formRegisterValido(),
                  onPressed: _submitForm,
                ),

                const SizedBox(height: 24),

                AuthLink(
                  onTap: _navigateToLogin,
                  title: "¿Ya tienes cuenta? ",
                  titleLink: "Inicia Sesión",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
