class MedicationIntake {
  final String intakeId;
  final String medicationId;
  final String elderId;
  final DateTime scheduledTime;
  final String status;
  final String medicationName;
  final String dosage;
  final DateTime? actualTime;
  final String? notes;

  MedicationIntake({
    required this.intakeId,
    required this.medicationId,
    required this.elderId,
    required this.scheduledTime,
    required this.status,
    required this.medicationName,
    required this.dosage,
    this.actualTime,
    this.notes,
  });
}
