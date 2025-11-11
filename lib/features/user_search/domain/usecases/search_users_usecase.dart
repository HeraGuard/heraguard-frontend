import 'package:heraguard_frontend/features/auth/data/models/auth_response.dart';
import 'package:heraguard_frontend/features/user_search/domain/repositories/user_search_repository.dart';

class SearchUsersUseCase {
  final UserSearchRepository repository;

  SearchUsersUseCase(this.repository);

  Future<List<User>> call({required String query, required int roleId}) async {
    return await repository.searchUsers(query: query, roleId: roleId);
  }
}
