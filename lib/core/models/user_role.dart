class AppRoute {
  final String name;
  final String path;

  AppRoute({required this.name, required this.path});
}

class UserRole {
  final String role;
  final List<AppRoute> routes;

  UserRole({required this.role, required this.routes});
}
