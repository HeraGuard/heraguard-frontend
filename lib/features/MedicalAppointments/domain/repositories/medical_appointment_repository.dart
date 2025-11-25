// lib/features/medical_appointments/domain/repositories/medical_appointment_repository.dart

import '../entities/medical_appointment.dart';

abstract class MedicalAppointmentRepository {
  Future<void> addMedicalAppointment(MedicalAppointment appointment);
  Future<void> syncPendingAppointments();
}
