import '../../domain/entities/medication_intake.dart';

class MedicationIntakeDto extends MedicationIntake {
  MedicationIntakeDto({
    required super.intakeId,
    required super.medicationId,
    required super.elderId,
    required super.scheduledTime,
    required super.status,
    required super.medicationName,
    required super.dosage,
    super.actualTime,
    super.notes,
  });

  factory MedicationIntakeDto.fromJson(Map<String, dynamic> json) {
    return MedicationIntakeDto(
      intakeId: json['scheduleId'] ?? '', // <-- backend usa 'scheduleId'
      medicationId: json['medicationId'] ?? '',
      elderId: json['elderId'] ?? '',
      scheduledTime: json['scheduledTime'] != null
          ? DateTime.parse(json['scheduledTime'])
          : DateTime.now(),
      status: json['status'] ?? '',
      medicationName: json['medicationName'] ?? '',
      dosage: json['dosage'] ?? '',
      actualTime: json['actualTime'] != null
          ? DateTime.tryParse(json['actualTime']) // puede venir como null
          : null,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scheduleId': intakeId,
      'medicationId': medicationId,
      'elderId': elderId,
      'scheduledTime': scheduledTime.toIso8601String(),
      'status': status,
      'medicationName': medicationName,
      'dosage': dosage,
      'actualTime': actualTime?.toIso8601String(),
      'notes': notes,
    };
  }
}
