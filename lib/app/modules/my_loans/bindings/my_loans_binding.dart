import 'package:get/get.dart';

import '../controllers/my_loans_controller.dart';

class MyLoansBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyLoansController>(
      () => MyLoansController(),
    );
  }
}
