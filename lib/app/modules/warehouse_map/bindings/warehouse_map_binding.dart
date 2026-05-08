import 'package:get/get.dart';

import '../controllers/warehouse_map_controller.dart';

class WarehouseMapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WarehouseMapController>(
      () => WarehouseMapController(),
    );
  }
}
