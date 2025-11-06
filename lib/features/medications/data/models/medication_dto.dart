import 'package:heraguard_frontend/features/medications/domain/entities/medication.dart';

class MedicationDto {
  final String name;
  final String description;
  final String dosage;
  final int frequency;
  final int duration;
  final String elderId;

  MedicationDto({
    required this.name,
    required this.description,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.elderId,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "dosage": dosage,
    "frequency": frequency,
    "duration": duration,
    "elderId": elderId,
  };

  factory MedicationDto.fromDomain(Medication med) => MedicationDto(
    name: med.name,
    description: med.description,
    dosage: med.dosage,
    frequency: med.frequency,
    duration: med.duration,
    elderId: med.elderId,
  );
}
