import 'package:heraguard_frontend/features/medications/domain/entities/medication_intake.dart';
import '../entities/medication.dart';

abstract class MedicationRepository {
  Future<void> addPrescription({
    required String elderId,
    required DateTime date,
    required List<Medication> medications,
  });

  Future<void> syncPendingMedications();

  Future<List<Medication>> getMedicationsByUser(String userId);
  Future<void> deleteMedication(String medicationId);

  Future<void> confirmIntake({
    required String intakeId,
    required DateTime actualTime,
    required String userId,
    String? notes,
  });

  Future<void> skipIntake({
    required String intakeId,
    required String userId,
    String? reason,
  });

  Future<MedicationIntake> getIntakeById(String intakeId);
}
