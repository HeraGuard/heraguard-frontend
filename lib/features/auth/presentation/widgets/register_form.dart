import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/widgets/custom_text_field.dart';
import 'package:heraguard_frontend/features/auth/presentation/widgets/toggle_role.dart';

class RegisterForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final String? selectedRole;
  final ValueChanged<bool> onObscurePasswordChanged;
  final ValueChanged<bool> onObscureConfirmPasswordChanged;
  final ValueChanged<String?> onRoleChanged;
  final ValueChanged<String>? onNameChanged;
  final ValueChanged<String>? onLastNameChanged;
  final ValueChanged<String>? onEmailChanged;
  final ValueChanged<String>? onPasswordChanged;
  final ValueChanged<String>? onConfirmPasswordChanged;

  const RegisterForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.selectedRole,
    required this.onObscurePasswordChanged,
    required this.onObscureConfirmPasswordChanged,
    required this.onRoleChanged,
    this.onEmailChanged,
    this.onPasswordChanged,
    this.onConfirmPasswordChanged,
    this.onNameChanged,
    this.onLastNameChanged,
    required this.nameController,
    required this.lastNameController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            CustomTextField(
              controller: nameController,
              label: 'Nombre',
              icon: Icons.person_outline,
              keyboardType: TextInputType.name,
              onChanged: onNameChanged,
              textCap: TextCapitalization.words,
            ),

            const SizedBox(height: 16),

            CustomTextField(
              controller: lastNameController,
              label: 'Apellido',
              icon: Icons.person_outline,
              keyboardType: TextInputType.name,
              onChanged: onLastNameChanged,
              textCap: TextCapitalization.words,
            ),

            const SizedBox(height: 16),

            CustomTextField(
              controller: emailController,
              label: 'Correo electrónico',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              onChanged: onEmailChanged,
            ),

            const SizedBox(height: 16),

            CustomTextField(
              controller: passwordController,
              label: "Contraseña",
              icon: Icons.lock_outline,
              obscureText: obscurePassword,
              onChanged: onPasswordChanged,
              suffixIcon: Icon(
                obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onSuffixIconPressed: () {
                onObscurePasswordChanged(!obscurePassword);
              },
            ),

            const SizedBox(height: 16),

            CustomTextField(
              controller: confirmPasswordController,
              label: "Confirmar contraseña",
              icon: Icons.lock_outline,
              obscureText: obscureConfirmPassword,
              onChanged: onConfirmPasswordChanged,
              suffixIcon: Icon(
                obscureConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onSuffixIconPressed: () {
                onObscureConfirmPasswordChanged(!obscureConfirmPassword);
              },
            ),

            const SizedBox(height: 16),

            ToggleRole(
              selectedRole: selectedRole,
              onRoleChanged: onRoleChanged,
            ),
          ],
        ),
      ],
    );
  }
}
