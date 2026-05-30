import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'api_client.dart';
import 'auth_service.dart';
import '../theme/app_theme.dart';
import '../routes/app_pages.dart';
import '../modules/home/controllers/home_controller.dart';
import '../modules/notifications/controllers/notifications_controller.dart';
import '../modules/my_loans/controllers/my_loans_controller.dart';

class FcmService extends GetxService {
  static FcmService get to => Get.find<FcmService>();

  final fcmToken = ''.obs;
  final FlutterLocalNotificationsPlugin _localNotifs =
      FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    // Inisialisasi notifikasi lokal bawaan sistem HP terlebih dahulu
    _initLocalNotifications().then((_) {
      _initializeFcm();
    });
  }

  /// Inisialisasi notifikasi lokal bawaan sistem HP
  Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotifs.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Ketika notifikasi diklik, arahkan pengguna ke halaman riwayat notifikasi
        Get.toNamed(Routes.NOTIFICATIONS);
      },
    );

    // Buat channel notifikasi untuk Android secara eksplisit agar dikenali sistem HP di background/foreground
    final androidPlugin = _localNotifs
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          'loan_alerts_channel_id',
          'Pemberitahuan Pinjaman',
          description:
              'Saluran untuk notifikasi persetujuan/penolakan pinjaman barang',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
        ),
      );
      debugPrint('[FCM] Channel notifikasi loan_alerts_channel_id berhasil didaftarkan secara programmatik');
    }
  }

  /// Inisialisasi Firebase Messaging
  Future<void> _initializeFcm() async {
    try {
      // 1. Minta izin notifikasi secara asinkron setelah user membuka aplikasi
      final messaging = FirebaseMessaging.instance;
      
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      debugPrint('[FCM] Status izin notifikasi: ${settings.authorizationStatus}');

      // 2. Dapatkan Token Perangkat FCM
      await fetchAndRegisterToken();

      // 3. Konfigurasi Pendengar Pesan di Foreground (Aplikasi aktif terbuka)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('[FCM] Pesan diterima di foreground: ${message.notification?.title}');
        _handleForegroundMessage(message);
      });

      // 4. Konfigurasi Pendengar Aksi Klik Notifikasi (Saat aplikasi dibuka dari tray)
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('[FCM] Aplikasi dibuka melalui notifikasi klik: ${message.data}');
        _handleNotificationClick(message);
      });

      // 5. Periksa apakah aplikasi dibuka pertama kali dari kondisi mati total (Terminated) via klik notifikasi
      final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        debugPrint('[FCM] Aplikasi dibuka dari terminated state via notifikasi');
        _handleNotificationClick(initialMessage);
      }
    } catch (e) {
      debugPrint('[FCM] Gagal inisialisasi FCM: $e');
    }
  }

  /// Ambil token perangkat FCM baru dan daftarkan ke database backend jika terautentikasi
  Future<void> fetchAndRegisterToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        fcmToken.value = token;
        debugPrint('[FCM] Token Perangkat berhasil diambil: $token');
        await registerDeviceToken();
      }
    } catch (e) {
      debugPrint('[FCM] Gagal mengambil token FCM: $e');
    }
  }

  /// Daftarkan token perangkat ke Laravel API backend
  Future<void> registerDeviceToken() async {
    if (fcmToken.value.isEmpty) return;

    final authToken = await AuthService.getToken();
    if (authToken == null || authToken.isEmpty) {
      debugPrint('[FCM] Pengguna belum login. Token disimpan lokal terlebih dahulu.');
      return;
    }

    try {
      final response = await ApiClient.dio.post(
        'auth/fcm-token',
        data: {'fcm_token': fcmToken.value},
      );

      if (response.statusCode == 200) {
        debugPrint('[FCM] Token perangkat sukses didaftarkan ke Laravel! 🚀');
      }
    } catch (e) {
      debugPrint('[FCM] Gagal mendaftarkan token ke Laravel: $e');
    }
  }

  /// Hapus token FCM saat logout
  Future<void> removeDeviceTokenOnLogout() async {
    try {
      final authToken = await AuthService.getToken();
      if (authToken != null && authToken.isNotEmpty) {
        await ApiClient.dio.post(
          'auth/fcm-token',
          data: {'fcm_token': null},
        );
        debugPrint('[FCM] Token perangkat di Laravel berhasil dihapus.');
      }
    } catch (e) {
      debugPrint('[FCM] Gagal menghapus token di Laravel: $e');
    }
  }

  /// Handle pesan ketika aplikasi berada di foreground
  void _handleForegroundMessage(RemoteMessage message) {
    // 1. Tampilkan Notifikasi Native Sistem HP (Heads-up banner) agar muncul di atas layar seperti SMS
    _showSystemNotification(message);

    // 2. Segarkan data halaman aktif secara real-time untuk memperbarui informasi di layar
    _refreshActiveData();
  }

  /// Memperbarui data secara asinkron pada controller GetX yang sedang aktif/terdaftar
  void _refreshActiveData() {
    try {
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().loadHomeData();
        debugPrint('[FCM] Data HomeController berhasil disegarkan secara real-time');
      }
      if (Get.isRegistered<NotificationsController>()) {
        Get.find<NotificationsController>().fetchNotifications();
        debugPrint('[FCM] Data NotificationsController berhasil disegarkan secara real-time');
      }
      if (Get.isRegistered<MyLoansController>()) {
        Get.find<MyLoansController>().fetchLoans();
        debugPrint('[FCM] Data MyLoansController berhasil disegarkan secara real-time');
      }
    } catch (e) {
      debugPrint('[FCM] Gagal menyegarkan data controller: $e');
    }
  }

  /// Menampilkan notifikasi native bawaan sistem HP (Heads-up banner)
  Future<void> _showSystemNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    Color color = AppColors.primary;
    final titleLower = (notification.title ?? '').toLowerCase();
    if (titleLower.contains('disetujui') || titleLower.contains('approve')) {
      color = AppColors.statusAvailable;
    } else if (titleLower.contains('ditolak') || titleLower.contains('reject')) {
      color = AppColors.statusOverdue;
    } else if (titleLower.contains('jatuh tempo') || titleLower.contains('tenggat')) {
      color = AppColors.statusPending;
    }

    final androidDetails = AndroidNotificationDetails(
      'loan_alerts_channel_id',
      'Pemberitahuan Pinjaman',
      channelDescription:
          'Saluran untuk notifikasi persetujuan/penolakan pinjaman barang',
      importance: Importance.max,
      priority: Priority.high,
      color: color,
      playSound: true,
      enableVibration: true,
    );

    final iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // ID unik agar tidak menimpa notifikasi sebelumnya
    final notifId = DateTime.now().millisecondsSinceEpoch.remainder(100000);

    await _localNotifs.show(
      notifId,
      notification.title,
      notification.body,
      notificationDetails,
    );
  }

  /// Menangani aksi klik pada notifikasi
  void _handleNotificationClick(RemoteMessage message) {
    debugPrint('[FCM] Notifikasi diklik: ${message.data}');
    Get.toNamed(Routes.NOTIFICATIONS);
  }
}
