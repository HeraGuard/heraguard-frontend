import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:heraguard_frontend/core/network/api_client.dart';
import 'package:heraguard_frontend/core/network/endpoints.dart';
import 'package:heraguard_frontend/core/storage/secure_storage.dart';
import 'package:heraguard_frontend/features/auth/data/models/auth_response.dart';
import 'package:heraguard_frontend/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient = ApiClient();
  final SecureStorage _secureStorage;

  AuthRepositoryImpl(this._secureStorage);

  @override
  Future<AuthResponse> login(String email, String password) async {
    final response = await _apiClient.post(Endpoints.login, {
      'email': email,
      'password': password,
    });

    final authResponse = AuthResponse.fromJson(response.data);

    await _secureStorage.write(
      key: 'access_token',
      value: authResponse.accessToken,
    );

    await _secureStorage.write(key: 'user_role', value: authResponse.user.role);

    // Token firebase
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print('FCM Token: $fcmToken');

    if (fcmToken != null) {
      // await _apiClient.post(
      //   '${Endpoints.deviceToken}/${authResponse.user.id}/device-token',
      //   {'deviceToken': fcmToken, 'platform': 'android'},
      // );
    }

    return authResponse;
  }

  @override
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

  @override
  Future<void> logout() async {
    await _secureStorage.delete(key: 'access_token');
    await _apiClient.post(Endpoints.logout, {});
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

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'access_token');
  }
}
