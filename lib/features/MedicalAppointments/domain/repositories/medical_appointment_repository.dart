import 'package:heraguard_frontend/features/MedicalAppointments/data/models/medical_appointment.dart';

abstract class MedicalAppointmentRepository {
  Future<MedicalAppointment> createMedicalAppointment(MedicalAppointment medicalappointment);

  Future<List<MedicalAppointment>> getMedicalAppointments();

  Future<MedicalAppointment> getMedicalAppointmentById(String medicalAppointmentId);

  Future<MedicalAppointment> updateMedicalAppointment(MedicalAppointment medicalappointment);

  Future<void> deleteMedicalAppointment(String medicalAppointmentId);
}
