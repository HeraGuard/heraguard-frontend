class MedicalAppointment {
  final String medicalAppointmentId;
  final String nameOfPatient;
  final DateTime date;
  final String time;
  final String description;
  final String doctorId;
  final String caregiverId;
  final String elderId;

  MedicalAppointment({
    required this.medicalAppointmentId,
    required this.nameOfPatient,
    required this.date,
    required this.time,
    required this.description,
    required this.doctorId,
    required this.caregiverId,
    required this.elderId,
  });

  factory MedicalAppointment.fromJson(Map<String, dynamic> json){
  return MedicalAppointment(
    medicalAppointmentId: json['medicalAppointmentId'],
    nameOfPatient: json['nameOfPatient'],
    date: DateTime.parse(json['date']),
    time: json['time'],
    description: json['description'],
    doctorId: json['doctorId'],
    caregiverId: json['caregiverId'],
    elderId: json['elderId'],
  );
}

Map<String, dynamic> toJson(){
  return {
    'medicalAppointmentId': medicalAppointmentId,
    'nameOfPatient': nameOfPatient,
    'date': date.toIso8601String(),
    'time': time,
    'description': description,
    'doctorId': doctorId,
    'caregiverId': caregiverId,
    'elderId': elderId,
  };
}

}
