import 'package:heraguard_frontend/features/auth/data/models/auth_response.dart';

abstract class AuthRepository {
  Future<AuthResponse> login(String email, String password);
  Future<AuthResponse> register(
    String name,
    String lastName,
    String email,
    String password,
    String role,
  );
}
