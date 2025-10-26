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
  
  Future<AuthResponse> register(
    String name,
    String lastName,
    String email,
    String password,
    String role,
  ) async {
    int idRole = _getIdRole(role);
    final response = await _apiClient.post(Endpoints.register, {
      'name': name,
      'lastName': lastName,
      'email': email,
      'password': password,
      'roleId': idRole,
    });
    return AuthResponse.fromJson(response.data);
  }

  int _getIdRole(String role) {
    switch (role) {
      case "adulto_mayor":
        return 1;
      case "cuidador":
        return 2;
      case "doctor":
        return 3;
      default:
        return 1;
    }
  }
}
