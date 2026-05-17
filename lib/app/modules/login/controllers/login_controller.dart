import 'package:get/get.dart';
import '../../../data/auth_service.dart';

class LoginController extends GetxController {
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
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
