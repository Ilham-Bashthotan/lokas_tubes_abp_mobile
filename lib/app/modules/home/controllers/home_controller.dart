import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../data/items_service.dart';
import '../../../data/loans_service.dart';
import '../../../data/item_model.dart';
import '../../../data/loan_model.dart';
import '../../../data/api_client.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final isLoading = false.obs;
  final availableItems = <Item>[].obs;
  final myLoans = <Loan>[].obs;
  
  final activeLoansCount = 0.obs;
  final pendingLoansCount = 0.obs;
  final totalLoansCount = 0.obs;
  final unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    try {
      isLoading.value = true;
      final availablePage = await ItemsService.fetchItems(status: 'available', perPage: 4);

      final activeLoans = await LoansService.fetchMyLoans(status: 'active', perPage: 4);
      final pendingLoans = await LoansService.fetchMyLoans(status: 'pending', perPage: 4);
      final allLoans = await LoansService.fetchMyLoans(perPage: 1);

      availableItems.value = availablePage.items;
      myLoans.value = [...pendingLoans.loans, ...activeLoans.loans];
      
      activeLoansCount.value = activeLoans.total;
      pendingLoansCount.value = pendingLoans.total;
      totalLoansCount.value = allLoans.total;
      
      // Ambil jumlah notifikasi belum dibaca
      await fetchUnreadCount();
    } catch (error) {
      debugPrint('[HOME] Error loading home data: $error');
      Get.snackbar('Terjadi kesalahan', 'Gagal mengambil data dari server: $error');
      // Jika gagal mengambil data krusial di beranda, kembalikan pengguna ke login
      Get.offAllNamed(Routes.LOGIN);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUnreadCount() async {
    try {
      final resp = await ApiClient.dio.get('notifications');
      if (resp.statusCode == 200) {
        unreadCount.value = resp.data['unread_count'] ?? 0;
      }
    } catch (e) {
      debugPrint('[HOME] Gagal mengambil unread count: $e');
    }
  }
}
