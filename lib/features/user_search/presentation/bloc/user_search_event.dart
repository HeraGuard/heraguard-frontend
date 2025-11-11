abstract class UserSearchEvent {}

class SearchUsersEvent extends UserSearchEvent {
  final String query;
  final int roleId;

  SearchUsersEvent({required this.query, required this.roleId});
}

class ClearSearchEvent extends UserSearchEvent {}
