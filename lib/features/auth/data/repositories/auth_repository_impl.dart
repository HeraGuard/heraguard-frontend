import 'package:heraguard_frontend/core/network/api_client.dart';
import 'package:heraguard_frontend/core/network/endpoints.dart';
import 'package:heraguard_frontend/features/auth/data/models/auth_response.dart';

class AuthRepositoryImpl {
  final ApiClient _apiClient = ApiClient();

  Future<AuthResponse> login(String email, String password) async {
    final response = await _apiClient.post(Endpoints.login, {
      'email': email,
      'password': password,
    });

    return AuthResponse.fromJson(response.data);
  }
}
