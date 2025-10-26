import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/widgets/custom_text_field.dart';
import 'package:heraguard_frontend/features/auth/presentation/widgets/remember_me_checkbox.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool rememberMe;
  final ValueChanged<bool> onObscurePasswordChanged;
  final ValueChanged<bool> onRememberMeChanged;
  final VoidCallback onForgotPassword;
  final ValueChanged<String>? onEmailChanged;
  final ValueChanged<String>? onPasswordChanged;
  final String? emailError;
  final String? passwordError;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.rememberMe,
    required this.onObscurePasswordChanged,
    required this.onRememberMeChanged,
    required this.onForgotPassword,
    this.onEmailChanged,
    this.onPasswordChanged, this.emailError, this.passwordError,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            CustomTextField(
              controller: emailController,
              label: 'Correo electrónico',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              onChanged: onEmailChanged,
              errorText: emailError,
            ),

            const SizedBox(height: 16),

            CustomTextField(
              controller: passwordController,
              label: "Contraseña",
              icon: Icons.lock_outline,
              obscureText: obscurePassword,
              onChanged: onPasswordChanged,
              errorText: passwordError,
              suffixIcon: Icon(
                obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onSuffixIconPressed: () {
                onObscurePasswordChanged(!obscurePassword);
              },
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RememberMeCheckbox(
                  value: rememberMe,
                  onChanged: onRememberMeChanged,
                ),
                TextButton(
                  onPressed: onForgotPassword,
                  child: Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(
                      color: const Color(0xFF0040FF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
