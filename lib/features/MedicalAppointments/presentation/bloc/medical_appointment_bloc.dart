import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/medical_appointment_repository.dart';
import 'medical_appointment_event.dart';
import 'medical_appointment_state.dart';

class MedicalAppointmentBloc
    extends Bloc<MedicalAppointmentEvent, MedicalAppointmentState> {
  final MedicalAppointmentRepository repository;

  MedicalAppointmentBloc({required this.repository})
      : super(MedicalAppointmentInitial()) {
    on<AddMedicalAppointmentEvent>(_onAddAppointment);
    on<SyncPendingAppointmentsEvent>(_onSyncPending);
  }

  Future<void> _onAddAppointment(
    AddMedicalAppointmentEvent event,
    Emitter<MedicalAppointmentState> emit,
  ) async {
    emit(MedicalAppointmentLoading());
    try {
      await repository.addMedicalAppointment(event.appointment);
      emit(MedicalAppointmentSuccess());
    } catch (e) {
      emit(MedicalAppointmentFailure(e.toString()));
    }
  }

  Future<void> _onSyncPending(
    SyncPendingAppointmentsEvent event,
    Emitter<MedicalAppointmentState> emit,
  ) async {
    emit(MedicalAppointmentLoading());
    try {
      await repository.syncPendingAppointments();
      emit(MedicalAppointmentSyncSuccess());
    } catch (e) {
      emit(MedicalAppointmentFailure('Error al sincronizar: ${e.toString()}'));
    }
  }
}
