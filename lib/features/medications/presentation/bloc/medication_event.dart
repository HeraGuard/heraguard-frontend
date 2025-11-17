import 'package:equatable/equatable.dart';
import '../../domain/entities/medication.dart';

abstract class MedicationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddMedicationEvent extends MedicationEvent {
  final String elderId;
  final DateTime date;
  final List<Medication> medications;

  AddMedicationEvent({
    required this.elderId,
    required this.date,
    required this.medications,
  });

  @override
  List<Object?> get props => [elderId, date, medications];
}

class SyncPendingMedicationsEvent extends MedicationEvent {}
