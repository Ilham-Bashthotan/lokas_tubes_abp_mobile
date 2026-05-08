import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  ApiClient._();

  static String _baseUrl() {
    final envUrl = dotenv.env['BASE_URL'];
    return envUrl != null && envUrl.isNotEmpty ? envUrl : 'http://192.168.18.103:8000/api/';
  }

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl(),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
}
