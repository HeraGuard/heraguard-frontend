import '../entities/medication.dart';

abstract class MedicationRepository {
  Future<void> addPrescription({
    required String elderId,
    required DateTime date,
    required List<Medication> medications,
  });

  Future<void> syncPendingMedications();

  Future<List<Medication>> getMedicationsByUser(String userId);
}
