// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/routes/route_utils.dart';
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
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _selectedRole;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _formRegisterValido() {
    return _nameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _selectedRole != null;
  }

  void _navigateToLogin() {
    RouteUtils.goBack(context);
  }

  void _submitForm() {
    print('Email: ${_emailController.text}');
    print('Password: ${_passwordController.text}');
    print('Rol: $_selectedRole');

    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isLoading = false);
    });
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
                  onEmailChanged: (value) => setState(() {}),
                  onPasswordChanged: (value) => setState(() {}),
                  onConfirmPasswordChanged: (value) => setState(() {}),
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
