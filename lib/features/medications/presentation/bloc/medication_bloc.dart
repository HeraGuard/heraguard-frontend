import 'package:flutter_bloc/flutter_bloc.dart';
import 'medication_event.dart';
import 'medication_state.dart';
import '../../domain/repositories/medication_repository.dart';

class MedicationBloc extends Bloc<MedicationEvent, MedicationState> {
  final MedicationRepository repository;

  MedicationBloc({required this.repository}) : super(MedicationInitial()) {
    on<AddMedicationEvent>(_onAddMedication);
    on<SyncPendingMedicationsEvent>(_onSyncPending);
  }

  Future<void> _onAddMedication(
    AddMedicationEvent event,
    Emitter<MedicationState> emit,
  ) async {
    emit(MedicationLoading());
    try {
      await repository.addPrescription(
        elderId: event.elderId,
        date: event.date,
        medications: event.medications,
      );
      emit(MedicationSuccess());
    } catch (e) {
      emit(MedicationFailure(e.toString()));
    }
  }

  Future<void> _onSyncPending(
    SyncPendingMedicationsEvent event,
    Emitter<MedicationState> emit,
  ) async {
    emit(MedicationLoading());
    try {
      await repository.syncPendingMedications();
      emit(MedicationSyncSuccess());
    } catch (e) {
      emit(MedicationFailure('Error al sincronizar: ${e.toString()}'));
    }
  }
}
