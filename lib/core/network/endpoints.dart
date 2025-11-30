class Endpoints {
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String prescriptions = '/api/Prescription';
  static const String medicalAppointment = '/api/MedicalAppointment';

  // Elder
  static const String getEldersByUser = '/api/Relationship/user';

  static const String linkElder = '/elders/link';
  static const String addActivity = '/api/Activity';

  // User search
  static const String searchUsers = '/api/User/search';
  static const String relationshipElder = '/api/Relationship';

  // Notifications
  static const String deviceToken = '/api/users';
}
