import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyMedicationsWidget extends StatelessWidget {
  const EmptyMedicationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.medication_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No hay medicamentos agregados',
            style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
