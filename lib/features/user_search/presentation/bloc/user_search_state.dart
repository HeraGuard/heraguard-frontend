import 'package:heraguard_frontend/features/auth/data/models/auth_response.dart';

abstract class UserSearchState {}

class UserSearchInitial extends UserSearchState {}

class UserSearchLoading extends UserSearchState {}

class UserSearchLoaded extends UserSearchState {
  final List<User> users;
  UserSearchLoaded(this.users);
}

class UserSearchEmpty extends UserSearchState {}

class UserSearchError extends UserSearchState {
  final String message;
  UserSearchError(this.message);
}
