import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heraguard_frontend/features/activities/domain/entities/activity.dart';
import 'package:heraguard_frontend/features/activities/domain/usecases/add_activity_usecase.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final AddActivityUsecase addActivityUsecase;

  ActivityBloc({required this.addActivityUsecase}) : super(ActivityInitial()) {
    on<AddActivity>(_onAddActivity);
  }

  Future<void> _onAddActivity(
    AddActivity event,
    Emitter<ActivityState> emit,
  ) async {
    emit(ActivityLoading());
    try {
      final activity = await addActivityUsecase(
        '',
        event.name,
        event.frequency,
        event.recommendedTime,
        event.duration,
        event.notes,
        event.elderId,
        event.doctorId,
        event.caregiverId,
      );
      emit(ActivityAdded(activity: activity));
    } catch (e) {
      emit(ActivityError(message: e.toString()));
    }
  }
}
