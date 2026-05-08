import 'package:get/get.dart';

import '../controllers/return_form_controller.dart';

class ReturnFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReturnFormController>(
      () => ReturnFormController(),
    );
  }
}
