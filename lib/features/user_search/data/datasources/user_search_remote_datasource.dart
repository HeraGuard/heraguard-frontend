import 'package:heraguard_frontend/core/network/api_client.dart';
import 'package:heraguard_frontend/core/network/endpoints.dart';
import 'package:heraguard_frontend/features/auth/data/models/auth_response.dart';

abstract class UserSearchRemoteDataSource {
  Future<List<User>> searchUsers({required String query, required int roleId});
}

class UserSearchRemoteDataSourceImpl implements UserSearchRemoteDataSource {
  final ApiClient apiClient;

  UserSearchRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<User>> searchUsers({
    required String query,
    required int roleId,
  }) async {
    try {
      final response = await apiClient.get(
        Endpoints.searchUsers,
        queryParameters: {'query': query, 'roleId': roleId},
      );

      final List<dynamic> data = response.data;
      return data.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al buscar usuarios: $e');
    }
  }
}
