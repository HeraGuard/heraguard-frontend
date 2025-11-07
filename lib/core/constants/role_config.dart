import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/models/user_role.dart';

class RoleConfig {
  static final Map<String, UserRole> roles = {
    'adulto_mayor': UserRole(
      role: 'adulto_mayor',
      routes: [
        AppRoute(
          name: 'home', 
          path: '/elder-home', 
          label: 'Home',
          showNav: true,
          icon: Icon(Icons.home),
        ),
        AppRoute(
          name: 'chats',
          path: '/doctor-chats',
          label: 'Chats',
          showNav: true,
          icon: Icon(Icons.chat),
        ),
        AppRoute(
          name: 'notifications',
          path: '/doctor-notifications',
          label: 'Notificaciones',
          showNav: true,
          icon: Icon(Icons.notifications),
        ),
        AppRoute(
          name: 'alert',
          path: '/elder-alert',
          label: 'Alert',
          showNav: true,
          icon: Icon(Icons.warning),
        ),
        AppRoute(
          name: 'settings',
          path: '/doctor-settings',
          label: 'Ajustes',
          showNav: true,
          icon: Icon(Icons.settings),
        ),
        AppRoute(
          name: 'addMedication',
          path: 'add-medication',
          label: 'Add Medication',
        ),
        AppRoute(
          name: 'addActivity',
          path: 'add-activity',
          label: 'Add Activity',
        ),
      ],
    ),
    'cuidador': UserRole(
      role: 'cuidador',
      routes: [
        AppRoute(name: 'home', path: '/caregiver-home', label: 'Home'),
        AppRoute(
          name: 'addMedication',
          path: 'add-medication',
          label: 'Add Medication',
        ),
        AppRoute(
          name: 'addActivity',
          path: 'add-activity',
          label: 'Add Activity',
        ),
      ],
    ),
    'doctor': UserRole(
      role: 'doctor',
      routes: [
        AppRoute(
          name: 'home',
          path: '/doctor-home',
          label: 'Home',
          showNav: true,
          icon: Icon(Icons.home),
        ),
        AppRoute(
          name: 'chats',
          path: '/doctor-chats',
          label: 'Chats',
          showNav: true,
          icon: Icon(Icons.chat),
        ),
        AppRoute(
          name: 'notifications',
          path: '/doctor-notifications',
          label: 'Notificaciones',
          showNav: true,
          icon: Icon(Icons.notifications),
        ),
        AppRoute(
          name: 'patients',
          path: '/patient-list',
          label: 'Pacientes',
          showNav: true,
          icon: Icon(Icons.people),
        ),
        AppRoute(
          name: 'settings',
          path: '/doctor-settings',
          label: 'Ajustes',
          showNav: true,
          icon: Icon(Icons.settings),
        ),
        AppRoute(
          name: 'addPatient',
          path: '/add-patient',
          label: 'Add Patient',
        ),
        AppRoute(
          name: 'addMedication',
          path: 'add-medication',
          label: 'Add Medication',
        ),
        AppRoute(
          name: 'addActivity',
          path: 'add-activity',
          label: 'Add Activity',
        ),
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

  static List<AppRoute> getNavBarRoutes(String role) {
    return getRole(role).routes.where((route) => route.showNav).toList();
  }
}
