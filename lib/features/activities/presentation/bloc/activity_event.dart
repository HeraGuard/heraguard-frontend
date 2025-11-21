part of 'activity_bloc.dart';

sealed class ActivityEvent {}

class AddActivity extends ActivityEvent {
  final String name;
  final String frequency;
  final TimeOfDay recommendedTime;
  final String duration;
  final String? notes;
  final String? elderId;
  final String? doctorId;
  final String? caregiverId;

  AddActivity({
    required this.name,
    required this.frequency,
    required this.recommendedTime,
    required this.duration,
    this.notes,
    this.elderId,
    this.doctorId,
    this.caregiverId,
  });
}