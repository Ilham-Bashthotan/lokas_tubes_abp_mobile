import 'package:get/get.dart';

import '../../../data/items_service.dart';
import '../../../data/loans_service.dart';
import '../../../data/item_model.dart';
import '../../../data/loan_model.dart';

class HomeController extends GetxController {
  final isLoading = false.obs;
  final availableItems = <Item>[].obs;
  final myActiveLoans = <Loan>[].obs;
  
  final activeLoansCount = 0.obs;
  final pendingLoansCount = 0.obs;
  final totalLoansCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    try {
      isLoading.value = true;
      final availablePage = await ItemsService.fetchItems(status: 'available', perPage: 4);

      final activeLoans = await LoansService.fetchMyLoans(status: 'active', perPage: 2);
      final pendingLoans = await LoansService.fetchMyLoans(status: 'pending', perPage: 1);
      final allLoans = await LoansService.fetchMyLoans(perPage: 1);

      availableItems.value = availablePage.items;
      myActiveLoans.value = activeLoans.loans;
      
      activeLoansCount.value = activeLoans.total;
      pendingLoansCount.value = pendingLoans.total;
      totalLoansCount.value = allLoans.total;
    } catch (error) {
      Get.snackbar('Terjadi kesalahan', 'Gagal mengambil data dari server');
    } finally {
      isLoading.value = false;
    }
  }
}
