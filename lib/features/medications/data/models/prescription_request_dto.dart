import 'package:heraguard_frontend/features/medications/data/models/medication_dto.dart';

class PrescriptionRequestDto {
  final String elderId;
  final String date;
  final List<MedicationDto> medications;

  PrescriptionRequestDto({
    required this.elderId,
    required this.date,
    required this.medications,
  });

  Map<String, dynamic> toJson() => {
    "elderId": elderId,
    "date": date,
    "medications": medications.map((m) => m.toJson()).toList(),
  };
}
