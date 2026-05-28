import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio_pkg;
import '../../../data/api_client.dart';
import '../../../data/auth_service.dart';
import '../../../data/notification_model.dart';
import '../../../theme/app_theme.dart';
import '../../../routes/app_pages.dart';

class NotificationsController extends GetxController {
  final notifications = <NotificationModel>[].obs;
  final isLoading = false.obs;
  final unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  /// Mengambil daftar riwayat notifikasi dari API
  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final resp = await ApiClient.dio.get('notifications');
      if (resp.statusCode == 200) {
        final body = resp.data as Map<String, dynamic>;
        final list = body['data'] as List;
        notifications.value = list
            .map((item) => NotificationModel.fromJson(item))
            .toList();
        unreadCount.value = body['unread_count'] ?? 0;
      }
    } catch (e) {
      debugPrint('[NOTIF] Gagal memuat notifikasi: $e');
      if (e is dio_pkg.DioException && e.response?.statusCode == 401) {
        debugPrint('[NOTIF] Sesi tidak valid (401). Mengeluarkan pengguna.');
        await AuthService.logout();
        Get.offAllNamed(Routes.LOGIN);
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Menandai satu notifikasi sebagai telah dibaca
  Future<void> markAsRead(int id) async {
    try {
      final resp = await ApiClient.dio.patch('notifications/$id/read');
      if (resp.statusCode == 200) {
        final idx = notifications.indexWhere((n) => n.id == id);
        if (idx != -1) {
          final updated = NotificationModel.fromJson(resp.data['data']);
          notifications[idx] = updated;

          if (unreadCount.value > 0) {
            unreadCount.value--;
          }
        }
      }
    } catch (e) {
      debugPrint('[NOTIF] Gagal menandai dibaca: $e');
    }
  }

  /// Menandai semua notifikasi milik user sebagai dibaca
  Future<void> markAllAsRead() async {
    if (notifications.isEmpty || unreadCount.value == 0) return;

    try {
      final resp = await ApiClient.dio.post('notifications/mark-all-read');
      if (resp.statusCode == 200) {
        // Ubah semua secara lokal menjadi read
        notifications.value = notifications.map((n) {
          return NotificationModel(
            id: n.id,
            loanId: n.loanId,
            type: n.type,
            message: n.message,
            isResolved: n.isResolved,
            isRead: true,
            alertedAt: n.alertedAt,
            loan: n.loan,
          );
        }).toList();

        unreadCount.value = 0;
        Get.snackbar(
          'Sukses',
          'Semua notifikasi ditandai dibaca',
          backgroundColor: AppColors.statusAvailable.withValues(alpha: 0.85),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );
      }
    } catch (e) {
      debugPrint('[NOTIF] Gagal menandai semua dibaca: $e');
    }
  }
}
