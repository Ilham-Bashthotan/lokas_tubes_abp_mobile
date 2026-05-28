import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart' hide Response;
import 'auth_service.dart';
import '../routes/app_pages.dart';

class ApiClient {
  ApiClient._();

  static String _baseUrl() {
    final envUrl = dotenv.env['BASE_URL'];
    return envUrl != null && envUrl.isNotEmpty
        ? envUrl
        : 'http://api.lokas-tubes-abp.test/api/';
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
          final token = await AuthService.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            debugPrint('[API] Terjadi error 401 Unauthorized. Mengeluarkan sesi dan kembali ke Login.');
            await AuthService.logout();
            Get.offAllNamed(Routes.LOGIN);
          }
          handler.next(e);
        },
      ),
    );

    return dio;
  }

  static final Dio dio = _buildDio();
}
