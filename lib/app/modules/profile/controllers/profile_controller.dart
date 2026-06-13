import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/auth_service.dart';
import '../../../data/fcm_service.dart';
import '../../../routes/app_pages.dart';
import '../../../controllers/theme_controller.dart';

class ProfileController extends GetxController {
  final count = 0.obs;
  // State
  final isLoading = false.obs;
  final isLoggingOut = false.obs;

  final userName = ''.obs;
  final userEmail = ''.obs;
  final userRole = ''.obs;
  final userId = 0.obs;

  // Lifecycle
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

  Future<void> fetchProfile({bool forceRefresh = false}) async {
    try {
      isLoading.value = true;

      final user = await AuthService.getProfile(forceRefresh: forceRefresh);
      if (user == null) {
        await AuthService.logout();
        Get.offAllNamed(Routes.LOGIN);
        return;
      }

      userId.value = user['id'] ?? 0;
      userName.value = user['name'] ?? '';
      userEmail.value = user['email'] ?? '';
      userRole.value = user['role'] ?? '';

      debugPrint('[PROFILE] User: ${userName.value}');
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // Logout
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
      
      // Hapus token perangkat FCM di Laravel sebelum logout
      if (Get.isRegistered<FcmService>()) {
        await FcmService.to.removeDeviceTokenOnLogout();
      }

      await AuthService.logout();
      isLoggingOut.value = false;
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  // Helpers
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

  // Theme toggle
  void toggleTheme() {
    final themeController = Get.find<ThemeController>();
    themeController.toggleDarkMode();
  }
}
