class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://localhost:8000/api/';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
