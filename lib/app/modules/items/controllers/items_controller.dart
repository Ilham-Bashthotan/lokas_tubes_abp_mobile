import 'package:get/get.dart';

import '../../../data/items_service.dart';
import '../../../data/item_model.dart';

class ItemsController extends GetxController {
  final items = <Item>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final search = ''.obs;
  final selectedStatus = 'all'.obs;
  final currentPage = 1.obs;
  final totalItems = 0.obs;
  final lastPage = 1.obs;

  @override
  void onInit() {
    super.onInit();
    debounce(search, (_) => fetchItems(), time: const Duration(milliseconds: 500));
    fetchItems();
  }

  Future<void> fetchItems() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final paged = await ItemsService.fetchItems(
        status: selectedStatus.value != 'all' ? selectedStatus.value : null,
        search: search.value,
        page: currentPage.value,
      );
      items.assignAll(paged.items);
      totalItems.value = paged.total;
      lastPage.value = paged.lastPage;
    } catch (_) {
      errorMessage.value = 'Terjadi kesalahan saat memuat data.';
    } finally {
      isLoading.value = false;
    }
  }

  void applyStatus(String status) {
    selectedStatus.value = status;
    currentPage.value = 1;
    fetchItems();
  }

  void onSearchChanged(String value) {
    search.value = value;
  }

  Future<void> refresh() async {
    await fetchItems();
  }
}
