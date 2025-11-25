import 'package:equatable/equatable.dart';

abstract class MedicalAppointmentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MedicalAppointmentInitial extends MedicalAppointmentState {}

class MedicalAppointmentLoading extends MedicalAppointmentState {}

class MedicalAppointmentSuccess extends MedicalAppointmentState {}

class MedicalAppointmentSyncSuccess extends MedicalAppointmentState {}

class MedicalAppointmentFailure extends MedicalAppointmentState {
  final String error;
  MedicalAppointmentFailure(this.error);

  @override
  List<Object?> get props => [error];
}
