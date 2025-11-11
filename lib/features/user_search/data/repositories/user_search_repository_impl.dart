import 'package:heraguard_frontend/features/auth/data/models/auth_response.dart';
import 'package:heraguard_frontend/features/user_search/data/datasources/user_search_remote_datasource.dart';
import 'package:heraguard_frontend/features/user_search/domain/repositories/user_search_repository.dart';

class UserSearchRepositoryImpl implements UserSearchRepository {
  final UserSearchRemoteDataSource remoteDataSource;

  UserSearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<User>> searchUsers({
    required String query,
    required int roleId,
  }) async {
    return await remoteDataSource.searchUsers(query: query, roleId: roleId);
  }
}
