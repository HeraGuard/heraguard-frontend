import '../../domain/entities/medication.dart';

class MedicationDto extends Medication {
  MedicationDto({
    required super.medicationId,
    required super.name,
    required super.description,
    required super.dosage,
    required super.frequency,
    required super.duration,
    required super.startDate,
    super.doctorId,
    required super.elderId,
    super.caregiverId,
    super.doctorName,
    super.caregiverName,
    required super.elderName,
  });

  // Método para convertir entidad dominio a DTO
  factory MedicationDto.fromDomain(Medication med) {
    return MedicationDto(
      medicationId: med.medicationId,
      name: med.name,
      description: med.description,
      dosage: med.dosage,
      frequency: med.frequency,
      duration: med.duration,
      startDate: med.startDate,
      doctorId: med.doctorId,
      elderId: med.elderId,
      caregiverId: med.caregiverId,
      doctorName: med.doctorName,
      caregiverName: med.caregiverName,
      elderName: med.elderName,
    );
  }

  factory MedicationDto.fromJson(Map<String, dynamic> json) {
    return MedicationDto(
      medicationId: json['medicationId'],
      name: json['name'],
      description: json['description'],
      dosage: json['dosage'],
      frequency: json['frequency'],
      duration: json['duration'],
      startDate: DateTime.parse(json['startDate']),
      doctorId: json['doctorId'],
      elderId: json['elderId'],
      caregiverId: json['caregiverId'],
      doctorName: json['doctorName'],
      caregiverName: json['caregiverName'],
      elderName: json['elderName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicationId': medicationId,
      'name': name,
      'description': description,
      'dosage': dosage,
      'frequency': frequency,
      'duration': duration,
      'startDate': startDate.toIso8601String(),
      'doctorId': doctorId,
      'elderId': elderId,
      'caregiverId': caregiverId,
      'doctorName': doctorName,
      'caregiverName': caregiverName,
      'elderName': elderName,
    };
  }
}
