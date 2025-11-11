import 'package:heraguard_frontend/features/auth/data/models/auth_response.dart';

abstract class UserSearchRepository {
  Future<List<User>> searchUsers({required String query, required int roleId});
}
