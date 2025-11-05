import 'package:flutter/material.dart';

class AppRoute {
  final String name;
  final String path;
  final bool showNav;
  final String label;
  final Icon icon;

  AppRoute({
    required this.name,
    required this.path,
    this.showNav = false,
    required this.label,
    this.icon = const Icon(Icons.category),
  });
}

class UserRole {
  final String role;
  final List<AppRoute> routes;

  UserRole({required this.role, required this.routes});
}
