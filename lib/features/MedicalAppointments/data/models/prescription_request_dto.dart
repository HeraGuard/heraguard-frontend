import 'medical_appointment_dto.dart';

class MedicalAppointmentRequestDto {
  final String elderId;
  final String date;
  final List<MedicalAppointmentDto> appointments;

  MedicalAppointmentRequestDto({
    required this.elderId,
    required this.date,
    required this.appointments,
  });

  Map<String, dynamic> toJson() => {
        "elderId": elderId,
        "date": date,
        "appointments": appointments.map((a) => a.toJson()).toList(),
      };
}