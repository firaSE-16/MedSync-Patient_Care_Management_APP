class ApiConstants {
  static const String baseUrl = 'http://localhost:5000/api';
  
  // Auth endpoints
  static const String registerPatient = '/auth/register/patient';
  static const String login = '/auth/login';
  
  // User endpoints
  static const String users = '/users';
  static String userById(String id) => '/users/$id';
}