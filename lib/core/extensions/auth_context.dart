import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/constants/role_config.dart';
import 'package:heraguard_frontend/core/models/user_role.dart';
import 'package:heraguard_frontend/core/providers/auth_provider.dart';
import 'package:heraguard_frontend/features/auth/data/models/auth_response.dart';
import 'package:provider/provider.dart';

extension AuthContext on BuildContext {
  AuthResponse? get authData => watch<AuthProvider>().authData;

  UserRole get userRole {
    final roleString = watch<AuthProvider>().userRole ?? 'adulto_mayor';
    return RoleConfig.getRole(roleString);
  }
}
