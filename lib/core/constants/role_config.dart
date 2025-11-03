import 'package:heraguard_frontend/core/models/user_role.dart';

class RoleConfig {
  static final Map<String, UserRole> roles = {
    'adulto_mayor': UserRole(
      role: 'adulto_mayor',
      routes: [AppRoute(name: 'home', path: '/elder-home')],
    ),
    'cuidador': UserRole(
      role: 'cuidador',
      routes: [AppRoute(name: 'home', path: '/caregiver-home')],
    ),
    'doctor': UserRole(
      role: 'doctor',
      routes: [
        AppRoute(name: 'home', path: '/doctor-home'),
        AppRoute(name: 'chats', path: '/doctor-chats'),
      ],
    ),
  };

  static UserRole getRole(String role) {
    return roles[role] ?? roles['adulto_mayor']!;
  }

  static String getHomeRoute(String role) {
    return getRole(role).routes.first.path;
  }

  static List<AppRoute> getRoutesForRole(String role) {
    return getRole(role).routes;
  }
}
