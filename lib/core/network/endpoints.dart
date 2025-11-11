class Endpoints {
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String prescriptions = '/api/Prescription';
  static const String medicalAppointment = '/api/MedicalAppointment';

  // Elder
  static const String getEldersByUser = '/api/Relationship/user';
  static const String linkElder = '/elders/link';

  // User search
  static const String searchUsers = '/api/User/search';
}
