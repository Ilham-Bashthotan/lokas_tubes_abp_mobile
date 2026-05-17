import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_client.dart';

class AuthService {
  AuthService._();
  static final _storage = const FlutterSecureStorage();
  static String? _cachedToken;
  static Map<String, dynamic>? _cachedProfile;

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
          _cachedToken = token.toString();
          await _storage.write(key: 'auth_token', value: _cachedToken!);
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
    _cachedToken = null;
    _cachedProfile = null;
    await _storage.delete(key: 'auth_token');
  }

  static Future<String?> getToken() async {
    if (_cachedToken != null) return _cachedToken;
    _cachedToken = await _storage.read(key: 'auth_token');
    return _cachedToken;
  }

  static Future<Map<String, dynamic>?> getProfile({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedProfile != null) return _cachedProfile;
    
    final token = await getToken();
    if (token == null) return null;

    try {
      final resp = await ApiClient.dio.get('auth/me');
      if (resp.statusCode == 200) {
        final body = resp.data as Map<String, dynamic>;
        final data = (body['data'] is Map) ? body['data'] as Map<String, dynamic> : body;
        final user = (data['user'] is Map) ? data['user'] as Map<String, dynamic> : data;
        _cachedProfile = user;
        return _cachedProfile;
      }
    } catch (e) {
      debugPrint('[AUTH] Failed to fetch profile: $e');
    }
    return null;
  }
}