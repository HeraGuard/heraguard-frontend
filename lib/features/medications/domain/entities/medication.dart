class Medication {
  final String medicationId;
  final String name;
  final String description;
  final String dosage;
  final int frequency;
  final int duration;
  final DateTime startDate;
  final String? doctorId;
  final String elderId;
  final String? caregiverId;
  final String? doctorName;
  final String? caregiverName;
  final String elderName;

  Medication({
    required this.medicationId,
    required this.name,
    required this.description,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.startDate,
    this.doctorId,
    required this.elderId,
    this.caregiverId,
    this.doctorName,
    this.caregiverName,
    required this.elderName,
  });
}
