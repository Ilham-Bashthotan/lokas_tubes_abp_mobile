import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_client.dart';

class AuthService {
  AuthService._();
  static final _storage = const FlutterSecureStorage();

  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final resp = await ApiClient.dio.post(
        'auth/login',
        data: {'email': email, 'password': password},
      );

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final body = resp.data as Map<String, dynamic>;
        debugPrint('[AUTH] Response: $body'); // lihat struktur asli

        // Cek nested 'data' dulu (Laravel standard), fallback ke root
        final payload = (body['data'] is Map)
            ? body['data'] as Map<String, dynamic>
            : body;

        final token = payload['token'] ??
            payload['access_token'] ??
            payload['accessToken'] ??
            body['token'] ??
            body['access_token'];

        debugPrint('[AUTH] Token: $token'); // null atau ada isinya?

        if (token != null) {
          await _storage.write(key: 'auth_token', value: token.toString());
          debugPrint('[AUTH] Token tersimpan ✅');
          return true;
        }

        debugPrint('[AUTH] ❌ Token tidak ditemukan di response!');
        return false;
      }
      return false;
    } on DioException catch (e) {
      debugPrint('[AUTH] Error: ${e.response?.statusCode} ${e.response?.data}');
      return false;
    }
  }

  static Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
  }

  static Future<String?> getToken() async =>
      _storage.read(key: 'auth_token');
}