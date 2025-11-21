part of 'activity_bloc.dart';

sealed class ActivityState {}

class ActivityInitial extends ActivityState {}

class ActivityLoading extends ActivityState {}

class ActivityAdded extends ActivityState {
  final Activity activity;

  ActivityAdded({required this.activity});
}

class ActivityError extends ActivityState {
  final String message;

  ActivityError({required this.message});
}