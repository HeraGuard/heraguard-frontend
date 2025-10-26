import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool readOnly;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final TextCapitalization textCap;
  final bool obscureText;
  final String? hintText;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final String? errorText;

  const CustomTextField({
    super.key,
    required this.controller,
    this.readOnly = false,
    required this.label,
    required this.icon,
    this.onTap,
    this.onChanged,
    this.keyboardType,
    this.textCap = TextCapitalization.none,
    this.obscureText = false,
    this.hintText,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      textCapitalization: textCap,
      obscureText: obscureText,
      cursorColor: const Color(0xFF0040FF),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        labelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        prefixIcon: Icon(
          icon,
          color: errorText != null ? Colors.red : const Color(0xFF0040FF),
        ),
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: suffixIcon!,
                onPressed: onSuffixIconPressed,
                color: errorText != null ? Colors.red : const Color(0xFF0040FF),
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: errorText != null ? Colors.red : Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: errorText != null ? Colors.red : const Color(0xFF0040FF),
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
      ),
      onTap: onTap,
      style: const TextStyle(fontSize: 16, color: Colors.black87),
    );
  }
}
