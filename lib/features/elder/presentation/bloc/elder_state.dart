part of 'elder_bloc.dart';

sealed class ElderState {}

class ElderInitial extends ElderState {}

class ElderLoading extends ElderState {}

class ElderLoaded extends ElderState {
  final List<Elder> elders;

  ElderLoaded({required this.elders});
}

class ElderLinkSuccess extends ElderState {}

class ElderError extends ElderState {
  final String message;

  ElderError({required this.message});
}
