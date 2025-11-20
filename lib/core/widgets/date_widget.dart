import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DateWidget extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onTap;
  final String? Function()? validator;

  const DateWidget({
    super.key,
    required this.selectedDate,
    required this.onTap,
    this.validator,
  });

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final dateText = selectedDate == null ? 'DD/MM/AAAA' : _formatDate(selectedDate!);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fecha',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextFormField(
              readOnly: true,
              style: GoogleFonts.roboto(fontSize: 18),
              decoration: InputDecoration(
                hintText: dateText,
                hintStyle: GoogleFonts.roboto(fontSize: 18, color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today, color: Color(0xFF1E88E5)),
                  onPressed: onTap,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                  borderSide: const BorderSide(color: Color(0xFF1E88E5), width: 2),
                ),
              ),
              onTap: onTap,
              validator: (_) => validator?.call(),
            ),
          ),
        ],
      ),
    );
  }
}