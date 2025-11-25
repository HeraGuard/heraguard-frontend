import '../../domain/entities/medical_appointment.dart';

class MedicalAppointmentDto extends MedicalAppointment {
  MedicalAppointmentDto({
    required super.medicalAppointmentId,
    required super.nameOfPatient,
    required super.date,
    required super.time,
    required super.description,
    super.doctorId,
    super.caregiverId,
    required super.elderId,
    super.doctorName,
    super.caregiverName,
    required super.elderName,
  });

  factory MedicalAppointmentDto.fromDomain(MedicalAppointment appt) {
    return MedicalAppointmentDto(
      medicalAppointmentId: appt.medicalAppointmentId,
      nameOfPatient: appt.nameOfPatient,
      date: appt.date,
      time: appt.time,
      description: appt.description,
      doctorId: appt.doctorId,
      caregiverId: appt.caregiverId,
      elderId: appt.elderId,
      doctorName: appt.doctorName,
      caregiverName: appt.caregiverName,
      elderName: appt.elderName,
    );
  }

  factory MedicalAppointmentDto.fromJson(Map<String, dynamic> json) {
    return MedicalAppointmentDto(
      medicalAppointmentId: json['medicalAppointmentId'],
      nameOfPatient: json['nameOfPatient'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      description: json['description'],
      doctorId: json['doctorId'],
      caregiverId: json['caregiverId'],
      elderId: json['elderId'],
      doctorName: json['doctorName'],
      caregiverName: json['caregiverName'],
      elderName: json['elderName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicalAppointmentId': medicalAppointmentId,
      'nameOfPatient': nameOfPatient,
      'date': date.toIso8601String(),
      'time': time,
      'description': description,
      'doctorId': doctorId,
      'caregiverId': caregiverId,
      'elderId': elderId,
      'doctorName': doctorName,
      'caregiverName': caregiverName,
      'elderName': elderName,
    };
  }
}
