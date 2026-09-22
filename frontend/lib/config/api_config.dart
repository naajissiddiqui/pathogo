class ApiConfig {
  
  static const String baseUrl = 'http://localhost:4000/api';

  
  static const String authRegister = '$baseUrl/auth/register';
  static const String authLogin = '$baseUrl/auth/login';
  static const String authMe = '$baseUrl/auth/me';
  static const String users = '$baseUrl/users';
  static const String packages = '$baseUrl/packages';
  static const String packageCategories = '$baseUrl/packages/categories';
  static const String tests = '$baseUrl/tests';
  static const String testCategories = '$baseUrl/tests/categories';
  static const String doctors = '$baseUrl/doctors';
  static const String doctorSpecialties = '$baseUrl/doctors/specialties';
  static const String bookings = '$baseUrl/bookings';
  static const String bookingsLookup = '$baseUrl/bookings/lookup';
  static const String appointments = '$baseUrl/appointments';
  static const String appointmentsLookup = '$baseUrl/appointments/lookup';
  static const String reviews = '$baseUrl/reviews';
  static const String partners = '$baseUrl/partners';
  static const String newsletter = '$baseUrl/newsletter/subscribe';

  
  static const Duration timeout = Duration(seconds: 10);
}
