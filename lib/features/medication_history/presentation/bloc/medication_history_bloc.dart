import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heraguard_frontend/features/medications/domain/repositories/medication_repository.dart';
import 'medication_history_event.dart';
import 'medication_history_state.dart';

class MedicationHistoryBloc
    extends Bloc<MedicationHistoryEvent, MedicationHistoryState> {
  final MedicationRepository medicationRepository;

  MedicationHistoryBloc({required this.medicationRepository})
    : super(MedicationHistoryInitial()) {
    on<LoadMedicationHistoryEvent>(_onLoadHistory);
    on<DeleteMedicationEvent>(_onDeleteMedication);
  }

  Future<void> _onLoadHistory(
    LoadMedicationHistoryEvent event,
    Emitter<MedicationHistoryState> emit,
  ) async {
    emit(MedicationHistoryLoading());
    try {
      final medications = await medicationRepository.getMedicationsByUser(
        event.userId,
      );

      if (medications.isEmpty) {
        emit(MedicationHistoryEmpty());
      } else {
        emit(MedicationHistoryLoaded(medications));
      }
    } catch (e) {
      emit(MedicationHistoryError(e.toString()));
    }
  }

  Future<void> _onDeleteMedication(
    DeleteMedicationEvent event,
    Emitter<MedicationHistoryState> emit,
  ) async {
    final currentState = state;

    emit(MedicationHistoryLoading());

    try {
      await medicationRepository.deleteMedication(event.medicationId);

      final medications = await medicationRepository.getMedicationsByUser(
        event.userId,
      );

      if (medications.isEmpty) {
        emit(MedicationHistoryEmpty());
      } else {
        emit(MedicationHistoryLoaded(medications));
      }
    } catch (e) {
      if (currentState is MedicationHistoryLoaded) {
        emit(currentState);
      }
      emit(MedicationHistoryError('Error al eliminar: ${e.toString()}'));
    }
  }
}
