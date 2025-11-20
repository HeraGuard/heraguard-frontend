import 'package:equatable/equatable.dart';

abstract class MedicationHistoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadMedicationHistoryEvent extends MedicationHistoryEvent {
  final String userId;

  LoadMedicationHistoryEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class DeleteMedicationEvent extends MedicationHistoryEvent {
  final String medicationId;
  final String userId;

  DeleteMedicationEvent(this.medicationId, this.userId);

  @override
  List<Object?> get props => [medicationId, userId];
}
