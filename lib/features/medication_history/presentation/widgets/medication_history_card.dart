import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heraguard_frontend/core/constants/app_colors.dart';
import 'package:heraguard_frontend/features/medications/domain/entities/medication.dart';
import 'package:intl/intl.dart';
import '../bloc/medication_history_bloc.dart';
import '../bloc/medication_history_event.dart';

class MedicationHistoryCard extends StatelessWidget {
  final Medication medication;
  final String userId;

  const MedicationHistoryCard({
    super.key,
    required this.medication,
    required this.userId,
  });

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final bloc = context.read<MedicationHistoryBloc>();

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.delete_outline, color: Colors.red),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '¿Eliminar medicamento?',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          '¿Estás seguro de que deseas eliminar "${medication.name}"? Esta acción no se puede deshacer.',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              'Cancelar',
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Eliminar',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (result == true) {
      await Future.delayed(const Duration(milliseconds: 100));
      bloc.add(DeleteMedicationEvent(medication.medicationId, userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 400),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.accentGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.medication,
                      color: AppColors.accentGreen,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medication.name,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          medication.elderName,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Botón de eliminar
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.red[400],
                    iconSize: 24,
                    onPressed: () => _showDeleteConfirmation(context),
                    tooltip: 'Eliminar medicamento',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoRow(
                Icons.description,
                'Descripción',
                medication.description,
              ),
              _buildInfoRow(Icons.science, 'Dosis', medication.dosage),
              if (medication.frequency > 0)
                _buildInfoRow(
                  Icons.schedule,
                  'Frecuencia',
                  'Cada ${medication.frequency} horas',
                ),
              if (medication.duration > 0)
                _buildInfoRow(
                  Icons.calendar_today,
                  'Duración',
                  '${medication.duration} días',
                ),
              if (medication.startDate.year > 1900)
                _buildInfoRow(
                  Icons.event,
                  'Inicio',
                  DateFormat('dd/MM/yyyy').format(medication.startDate),
                ),
              if (medication.doctorName != null)
                _buildInfoRow(Icons.person, 'Doctor', medication.doctorName!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
