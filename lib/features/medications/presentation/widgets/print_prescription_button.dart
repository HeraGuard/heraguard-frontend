import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heraguard_frontend/core/constants/app_colors.dart';

class PrintPrescriptionButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onPressed;

  const PrintPrescriptionButton({
    super.key,
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton.icon(
          onPressed: isEnabled ? onPressed : null,
          icon: const Icon(Icons.print, color: Colors.white),
          label: Text(
            'Visualizar Receta',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            disabledBackgroundColor: Colors.grey,
          ),
        ),
      ),
    );
  }
}
