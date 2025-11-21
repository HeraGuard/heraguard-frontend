import 'package:equatable/equatable.dart';
import 'package:heraguard_frontend/features/medications/domain/entities/medication.dart';

abstract class MedicationHistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MedicationHistoryInitial extends MedicationHistoryState {}

class MedicationHistoryLoading extends MedicationHistoryState {}

class MedicationHistoryLoaded extends MedicationHistoryState {
  final List<Medication> medications;

  MedicationHistoryLoaded(this.medications);

  @override
  List<Object?> get props => [medications];
}

class MedicationHistoryEmpty extends MedicationHistoryState {}

class MedicationHistoryError extends MedicationHistoryState {
  final String message;

  MedicationHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
