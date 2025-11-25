class MedicalAppointment {
  final String medicalAppointmentId;
  final String nameOfPatient;
  final DateTime date;
  final String time;
  final String description;
  final String? doctorId;
  final String? caregiverId;
  final String elderId;
  final String? doctorName;
  final String? caregiverName;
  final String elderName;

  MedicalAppointment({
    required this.medicalAppointmentId,
    required this.nameOfPatient,
    required this.date,
    required this.time,
    required this.description,
    this.doctorId,
    this.caregiverId,
    required this.elderId,
    this.doctorName,
    this.caregiverName,
    required this.elderName,
  });
}
