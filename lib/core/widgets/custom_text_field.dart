import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heraguard_frontend/core/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool readOnly;
  final String label;
  final IconData? icon;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final TextCapitalization textCap;
  final bool obscureText;
  final String? hintText;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final String? errorText;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    required this.controller,
    this.readOnly = false,
    required this.label,
    this.icon,
    this.onTap,
    this.onChanged,
    this.keyboardType,
    this.textCap = TextCapitalization.none,
    this.obscureText = false,
    this.hintText,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.errorText,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      textCapitalization: textCap,
      obscureText: obscureText,
      maxLines: obscureText ? 1 : maxLines,
      minLines: obscureText ? 1 : minLines,
      cursorColor: AppColors.primaryBlue,
      onChanged: onChanged,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        labelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        hintStyle: GoogleFonts.roboto(fontSize: 18, color: Colors.grey[600]),
        prefixIcon: icon != null
            ? Icon(icon, color: errorText != null ? Colors.red : AppColors.primaryBlue)
            : null,
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: suffixIcon!,
                onPressed: onSuffixIconPressed,
                color: errorText != null ? Colors.red : Colors.blue,
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
            color: errorText != null ? Colors.red : Colors.blue,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        alignLabelWithHint: maxLines != null && minLines! > 1,
      ),
      onTap: onTap,
      style: const TextStyle(fontSize: 16, color: Colors.black87),
    );
  }
}
