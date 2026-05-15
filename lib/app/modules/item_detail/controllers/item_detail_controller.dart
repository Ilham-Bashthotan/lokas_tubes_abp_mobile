import 'package:get/get.dart';

import '../../../data/dummy_items.dart';
import '../../../data/item_model.dart';

class ItemDetailController extends GetxController {
  final item = Rxn<Item>();
  final isLoading = false.obs;
  final errorMessage = RxnString();

  int? get itemId {
    final args = Get.arguments;
    if (args == null) return null;
    if (args is int) return args;
    if (args is String) return int.tryParse(args);
    if (args is Map && args['id'] != null) {
      return int.tryParse('${args['id']}');
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    loadItem();
  }

  Future<void> loadItem() async {
    final id = itemId;
    if (id == null) {
      errorMessage.value = 'ID barang tidak ditemukan.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    await Future.delayed(const Duration(milliseconds: 250));
    final foundItem = DummyItems.findById(id);
    if (foundItem == null) {
      errorMessage.value = 'Barang tidak ditemukan.';
    } else {
      item.value = foundItem;
    }
    isLoading.value = false;
  }
}
