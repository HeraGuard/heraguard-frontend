import 'package:equatable/equatable.dart';
import '../../domain/entities/medical_appointment.dart';

abstract class MedicalAppointmentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddMedicalAppointmentEvent extends MedicalAppointmentEvent {
  final MedicalAppointment appointment;

  AddMedicalAppointmentEvent(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

class SyncPendingAppointmentsEvent extends MedicalAppointmentEvent {}
