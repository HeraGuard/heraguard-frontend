import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:heraguard_frontend/core/storage/secure_storage.dart';
import 'package:heraguard_frontend/features/auth/data/models/auth_response.dart';

class AuthProvider with ChangeNotifier {
  AuthResponse? _authData;
  AuthResponse? get authData => _authData;

  String? _userRole;
  String? get userRole => _userRole;

  final SecureStorage _secureStorage;

  AuthProvider(this._secureStorage);

  String? _token;
  String? get token => _token;

  void setAuthData(AuthResponse authResponse) {
    _authData = authResponse;
    _userRole = authResponse.user.role;
    notifyListeners();
  }

  Future<void> loadSession() async {
    _token = await _secureStorage.read(key: 'access_token');
    _userRole = await _secureStorage.read(key: 'user_role');
    notifyListeners();
  }

  Future<void> saveSession(String token) async {
    await _secureStorage.write(key: 'access_token', value: token);
    _token = token;
    notifyListeners();
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'access_token');
    await _secureStorage.delete(key: 'user_role');
    _token = null;
    _authData = null;
    _userRole = null;
    notifyListeners();
  }
}
