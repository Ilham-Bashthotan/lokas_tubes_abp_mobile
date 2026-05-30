import 'package:get/get.dart';
import '../../../data/loans_service.dart';
import '../../../data/loan_model.dart';

class ReturnFormController extends GetxController {
  final loanData = Rx<Loan?>(null);

  final conditionAfter = ''.obs;
  final note = ''.obs;
  final photoPath = ''.obs;
  final isLoading = false.obs;

  bool get isValid => conditionAfter.value.isNotEmpty && photoPath.value.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Loan) {
      loanData.value = args;
    }
  }

  void setCondition(String condition) {
    conditionAfter.value = condition;
  }

  void setNote(String value) {
    note.value = value;
  }

  void setPhotoPath(String path) {
    photoPath.value = path;
  }

  Future<void> submitReturn() async {
    final loan = loanData.value;
    if (loan == null) {
      Get.snackbar('Error', 'Data peminjaman tidak ditemukan');
      return;
    }

    if (!isValid) {
      Get.snackbar('Error', 'Kondisi barang dan foto kondisi saat kembali harus diisi');
      return;
    }

    try {
      isLoading.value = true;
      await LoansService.returnItem(
        loanId: loan.id,
        conditionAfter: conditionAfter.value,
        note: note.value,
        photoPath: photoPath.value.isNotEmpty ? photoPath.value : null,
      );

      Get.snackbar('Sukses', 'Barang berhasil dikembalikan');
      Get.offAllNamed('/my-loans');
    } catch (e) {
      Get.snackbar('Error', 'Gagal memproses pengembalian barang');
    } finally {
      isLoading.value = false;
    }
  }
}
