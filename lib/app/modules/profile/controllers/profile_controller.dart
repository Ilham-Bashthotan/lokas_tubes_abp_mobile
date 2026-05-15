import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/api_client.dart';
import '../../../data/auth_service.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  final count = 0.obs;
  // ── State ──────────────────────────────────────────────
  final isLoading = false.obs;
  final isLoggingOut = false.obs;

  final userName = ''.obs;
  final userEmail = ''.obs;
  final userRole = ''.obs;
  final userId = 0.obs;

  // ── Lifecycle ──────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  // ── API Call ───────────────────────────────────────────
  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;

      final token = await AuthService.getToken();
      if (token == null) {
        Get.offAllNamed(Routes.LOGIN);
        return;
      }

      final resp = await ApiClient.dio.get(
        'auth/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (resp.statusCode == 200) {
        final body = resp.data as Map<String, dynamic>;
        debugPrint('[PROFILE] Response: $body');

        // Cek nested 'data' dulu
        final data = (body['data'] is Map)
            ? body['data'] as Map<String, dynamic>
            : body;

        // Response auth/me mungkin punya 'user' di dalam 'data'
        final user = (data['user'] is Map)
            ? data['user'] as Map<String, dynamic>
            : data;

        userId.value = user['id'] ?? 0;
        userName.value = user['name'] ?? '';
        userEmail.value = user['email'] ?? '';
        userRole.value = user['role'] ?? '';

        debugPrint('[PROFILE] User: ${userName.value}');
      }
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401) {
        await AuthService.logout();
        Get.offAllNamed(Routes.LOGIN);
      } else {
        Get.snackbar(
          'Gagal memuat profil',
          e.message ?? 'Terjadi kesalahan',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // ── Logout ─────────────────────────────────────────────
  Future<void> logout() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      isLoggingOut.value = true;
      await AuthService.logout();
      isLoggingOut.value = false;
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  // ── Helpers ────────────────────────────────────────────
  String get roleLabel {
    switch (userRole.value.toLowerCase()) {
      case 'admin':
        return 'Admin';
      case 'staff':
        return 'Staff';
      default:
        return userRole.value;
    }
  }

  String get avatarInitials {
    final parts = userName.value.trim().split(' ');
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}
