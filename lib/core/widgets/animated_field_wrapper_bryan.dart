import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AnimatedFieldWrapper extends StatelessWidget {
  final String label;
  final Widget field;
  final int durationMs;

  const AnimatedFieldWrapper({
    super.key,
    required this.label,
    required this.field,
    this.durationMs = 600,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: Duration(milliseconds: durationMs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: field,
          ),
        ],
      ),
    );
  }
}
