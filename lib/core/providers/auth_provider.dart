import 'package:flutter/foundation.dart';
import 'package:heraguard_frontend/features/auth/data/models/auth_response.dart';

class AuthProvider with ChangeNotifier {
  AuthResponse? _authData;

  AuthResponse? get authData => _authData;
  String? get userRole => _authData?.user.role;

  void setAuthData(AuthResponse authResponse) {
    _authData = authResponse;
    notifyListeners();
  }
}
