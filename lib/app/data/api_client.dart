import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  ApiClient._();

  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static String _baseUrl() {
    final envUrl = dotenv.env['BASE_URL'];
    return envUrl != null && envUrl.isNotEmpty
        ? envUrl
        : 'http://api.lokas-tubes-abp.test/api/';
  }

  static Future<String?> _getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  static Dio _buildDio() {
    final dio = Dio(
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

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );

    return dio;
  }

  static final Dio dio = _buildDio();
}
