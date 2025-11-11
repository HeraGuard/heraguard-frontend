import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class InputDecorationHelper {
  InputDecorationHelper._();

  static InputDecoration customDecoration({
    required String hint,
    IconData? icon,
    VoidCallback? onIconTap,
    bool isMultiline = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.roboto(fontSize: 18, color: Colors.grey[600]),
      filled: true,
      fillColor: AppColors.cardColor,
      prefixIcon:
          prefixIcon ??
          (icon != null && onIconTap == null
              ? Container(
                  padding: EdgeInsets.only(top: isMultiline ? 16 : 0, left: 12),
                  child: Icon(icon, color: AppColors.primaryBlue, size: 24),
                )
              : null),
      suffixIcon:
          suffixIcon ??
          (onIconTap != null
              ? IconButton(
                  icon: Icon(icon, color: AppColors.primaryBlue),
                  onPressed: onIconTap,
                )
              : null),
      contentPadding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: isMultiline ? 20 : 20,
        bottom: isMultiline ? 20 : 20,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
      ),
    );
  }
}
