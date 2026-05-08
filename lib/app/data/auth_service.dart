import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_client.dart';

class AuthService {
  AuthService._();

  static final _storage = const FlutterSecureStorage();

  /// Perform login. Returns true on success and stores token in secure storage.
  static Future<bool> login({required String email, required String password}) async {
    try {
      final resp = await ApiClient.dio.post('auth/login', data: {
        'email': email,
        'password': password,
      });

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final data = resp.data;
        // Expecting token somewhere in response; try common keys
        final token = data['token'] ?? data['access_token'] ?? data['accessToken'];
        if (token != null) {
          await _storage.write(key: 'auth_token', value: token.toString());
        }
        return true;
      }

      return false;
    } on DioException catch (e) {
      // bubble up or handle as needed
      return false;
    }
  }

  static Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
  }

  static Future<String?> getToken() async => await _storage.read(key: 'auth_token');
}
