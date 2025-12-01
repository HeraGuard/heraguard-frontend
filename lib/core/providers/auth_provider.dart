import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:heraguard_frontend/core/storage/secure_storage.dart';
import 'package:heraguard_frontend/features/auth/data/models/auth_response.dart';

class AuthProvider with ChangeNotifier {
  AuthResponse? _authData;
  AuthResponse? get authData => _authData;

  String? _userRole;
  String? get userRole => _userRole;

  String? _userId;  
  String? get userId => _userId; 

  final SecureStorage _secureStorage;

  AuthProvider(this._secureStorage);

  String? _token;
  String? get token => _token;

  void setAuthData(AuthResponse authResponse) {
    _authData = authResponse;
    _userRole = authResponse.user.role;
    _userId = authResponse.user.id; 
    notifyListeners();
  }

  Future<void> loadSession() async {
    _token = await _secureStorage.read(key: 'access_token');
    _userRole = await _secureStorage.read(key: 'user_role');
    _userId = await _secureStorage.read(key: 'user_id'); 
    notifyListeners();
  }

  Future<void> saveSession(String token, String userId, String userRole) async {  // ← MODIFICADO
    await _secureStorage.write(key: 'access_token', value: token);
    await _secureStorage.write(key: 'user_id', value: userId);
    await _secureStorage.write(key: 'user_role', value: userRole);
    _token = token;
    _userId = userId;
    _userRole = userRole;
    notifyListeners();
  }

  Future<void> logout() async {
    await _secureStorage.deleteAll();
    _token = null;
    _authData = null;
    _userRole = null;
    _userId = null;
    notifyListeners();
  }
}
