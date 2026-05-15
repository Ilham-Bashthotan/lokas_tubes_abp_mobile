import 'package:get/get.dart';

class LoanFormController extends GetxController {
  // Item data dari arguments
  final itemData = Rx<Map<String, dynamic>?>(null);

  // Form fields
  final startDate = ''.obs;
  final endDate = ''.obs;
  final notes = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Ambil data item dari arguments
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      itemData.value = args;
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void setStartDate(String date) {
    startDate.value = date;
  }

  void setEndDate(String date) {
    endDate.value = date;
  }

  void setNotes(String value) {
    notes.value = value;
  }

  void submitLoanRequest() {
    // TODO: Implement API call untuk submit loan request
    // Untuk sekarang, navigasi kembali ke home atau my loans
    Get.offAllNamed('/home');
  }
}
