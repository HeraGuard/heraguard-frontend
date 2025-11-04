import 'package:heraguard_frontend/core/models/user_role.dart';

class RoleConfig {
  static final Map<String, UserRole> roles = {
    'adulto_mayor': UserRole(
      role: 'adulto_mayor',
      routes: [
        AppRoute(name: 'home', path: '/elder-home'),
        AppRoute(name: 'addMedication', path: 'add-medication'),
        AppRoute(name: 'addActivity', path: 'add-activity'),
      ],
    ),
    'cuidador': UserRole(
      role: 'cuidador',
      routes: [
        AppRoute(name: 'home', path: '/caregiver-home'),
        AppRoute(name: 'addMedication', path: 'add-medication'),
        AppRoute(name: 'addActivity', path: 'add-activity'),
      ],
    ),
    'doctor': UserRole(
      role: 'doctor',
      routes: [
        AppRoute(name: 'home', path: '/doctor-home'),
        AppRoute(name: 'chats', path: '/doctor-chats'),
        AppRoute(name: 'addMedication', path: 'add-medication'),
        AppRoute(name: 'addActivity', path: 'add-activity'),
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
