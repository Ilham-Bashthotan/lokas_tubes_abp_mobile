import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../data/auth_service.dart';
import '../../../data/fcm_service.dart';

class LoginController extends GetxController {
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _checkSession();
  }

  Future<void> _checkSession() async {
    try {
      final token = await AuthService.getToken();
      if (token != null && token.isNotEmpty) {
        isLoading.value = true;
        final profile = await AuthService.getProfile(forceRefresh: true);
        isLoading.value = false;
        
        if (profile != null) {
          final role = (profile['role'] ?? '').toString().toLowerCase();
          if (role == 'staff') {
            // Ambil token perangkat dan daftarkan ke backend
            if (Get.isRegistered<FcmService>()) {
              FcmService.to.fetchAndRegisterToken();
            }
            Get.offAllNamed('/home');
            return;
          }
        }
        // Jika token tidak valid atau bukan staff, logout & bersihkan
        await AuthService.logout();
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint('[LOGIN] Gagal memproses session otomatis: $e');
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> login({required String email, required String password}) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Email dan password harus diisi');
      return;
    }

    try {
      isLoading.value = true;
      final ok = await AuthService.login(email: email, password: password);
      isLoading.value = false;

      if (ok) {
        final profile = await AuthService.getProfile(forceRefresh: true);
        final role = (profile?['role'] ?? '').toString().toLowerCase();

        if (role != 'staff') {
          await AuthService.logout();
          Get.snackbar(
            'Akses Ditolak',
            'Hanya pengguna dengan role staff yang dapat masuk',
          );
          return;
        }

        // Ambil token perangkat dan daftarkan ke backend
        if (Get.isRegistered<FcmService>()) {
          await FcmService.to.fetchAndRegisterToken();
        }

        Get.offAllNamed('/home');
      } else {
        Get.snackbar('Login Gagal', 'Periksa kredensial atau koneksi');
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }
}
