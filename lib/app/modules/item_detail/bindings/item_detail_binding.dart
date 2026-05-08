import 'package:get/get.dart';

import '../controllers/item_detail_controller.dart';

class ItemDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ItemDetailController>(
      () => ItemDetailController(),
    );
  }
}
