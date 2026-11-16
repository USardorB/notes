abstract final class ApiEndpoints {
  static const String baseUrl = 'https://api.example-notes.com/v1';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String logout = '/auth/logout';

  // Notes Sync
  static const String notes = '/notes';
}
