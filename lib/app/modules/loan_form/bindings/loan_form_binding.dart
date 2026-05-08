import 'package:get/get.dart';

import '../controllers/loan_form_controller.dart';

class LoanFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoanFormController>(
      () => LoanFormController(),
    );
  }
}
