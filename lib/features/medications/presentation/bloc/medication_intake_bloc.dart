import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heraguard_frontend/features/medications/domain/entities/medication_intake.dart';
import 'package:heraguard_frontend/features/medications/domain/repositories/medication_repository.dart';

abstract class MedicationIntakeEvent {}

class LoadIntake extends MedicationIntakeEvent {
  final String intakeId;
  LoadIntake(this.intakeId);
}

class ConfirmIntake extends MedicationIntakeEvent {
  final String intakeId;
  final DateTime actualTime;
  final String userId;
  final String? notes;
  ConfirmIntake(this.intakeId, this.actualTime, this.userId, {this.notes});
}

class SkipIntake extends MedicationIntakeEvent {
  final String intakeId;
  final String userId;
  final String? reason;
  SkipIntake(this.intakeId, this.userId, {this.reason});
}

abstract class MedicationIntakeState {}

class IntakeLoading extends MedicationIntakeState {}

class IntakeLoaded extends MedicationIntakeState {
  final MedicationIntake intake;
  IntakeLoaded(this.intake);
}

class IntakeSuccess extends MedicationIntakeState {}

class IntakeFailure extends MedicationIntakeState {
  final String error;
  IntakeFailure(this.error);
}

class MedicationIntakeBloc
    extends Bloc<MedicationIntakeEvent, MedicationIntakeState> {
  final MedicationRepository repository;

  MedicationIntakeBloc({required this.repository}) : super(IntakeLoading()) {
    on<LoadIntake>((event, emit) async {
      emit(IntakeLoading());
      try {
        final intake = await repository.getIntakeById(event.intakeId);
        emit(IntakeLoaded(intake));
      } catch (e) {
        emit(IntakeFailure(e.toString()));
      }
    });

    on<ConfirmIntake>((event, emit) async {
      emit(IntakeLoading());
      try {
        await repository.confirmIntake(
          intakeId: event.intakeId,
          actualTime: event.actualTime,
          userId: event.userId,
          notes: event.notes,
        );
        emit(IntakeSuccess());
      } catch (e) {
        emit(IntakeFailure(e.toString()));
      }
    });

    on<SkipIntake>((event, emit) async {
      emit(IntakeLoading());
      try {
        await repository.skipIntake(
          intakeId: event.intakeId,
          userId: event.userId,
          reason: event.reason,
        );
        emit(IntakeSuccess());
      } catch (e) {
        emit(IntakeFailure(e.toString()));
      }
    });
  }
}
