import 'package:get/get.dart';

import '../../../data/items_service.dart';
import '../../../data/item_model.dart';

class HomeController extends GetxController {
  final isLoading = false.obs;
  final availableItems = <Item>[].obs;
  final borrowedCount = 0.obs;
  final maintenanceCount = 0.obs;
  final totalCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    try {
      isLoading.value = true;
      final availablePage = await ItemsService.fetchItems(status: 'available', perPage: 4);

      final borrowedTotal = await ItemsService.fetchItemsTotal(status: 'borrowed');
      final maintenanceTotal = await ItemsService.fetchItemsTotal(status: 'maintenance');
      final totalItems = await ItemsService.fetchItemsTotal();

      availableItems.value = availablePage.items;
      borrowedCount.value = borrowedTotal;
      maintenanceCount.value = maintenanceTotal;
      totalCount.value = totalItems;
    } catch (error) {
      Get.snackbar('Terjadi kesalahan', 'Gagal mengambil data dari server');
    } finally {
      isLoading.value = false;
    }
  }
}
