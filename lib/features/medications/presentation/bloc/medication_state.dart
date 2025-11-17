import 'package:equatable/equatable.dart';

abstract class MedicationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MedicationInitial extends MedicationState {}

class MedicationLoading extends MedicationState {}

class MedicationSuccess extends MedicationState {}

class MedicationSyncSuccess extends MedicationState {}

class MedicationFailure extends MedicationState {
  final String error;
  MedicationFailure(this.error);

  @override
  List<Object?> get props => [error];
}
