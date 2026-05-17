import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/item_model.dart';
import '../../../data/loans_service.dart';

class LoanFormController extends GetxController {
  // Item data dari arguments
  final itemData = Rx<Item?>(null);

  // Form fields
  final startDate = ''.obs;
  final endDate = ''.obs;
  final notes = ''.obs;
  final photoPath = ''.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Ambil data item dari arguments
    final args = Get.arguments;
    if (args is Item) {
      itemData.value = args;
    }
    // Set tanggal pinjam otomatis ke hari ini
    startDate.value = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  bool get isValid =>
      startDate.value.isNotEmpty &&
      endDate.value.isNotEmpty &&
      notes.value.isNotEmpty &&
      photoPath.value.isNotEmpty;

  void setStartDate(String date) {
    startDate.value = date;
  }

  void setEndDate(String date) {
    endDate.value = date;
  }

  void setNotes(String value) {
    notes.value = value;
  }

  void setPhotoPath(String path) {
    photoPath.value = path;
  }

  Future<void> submitLoanRequest() async {
    final item = itemData.value;
    if (item == null) {
      Get.snackbar('Error', 'Barang tidak ditemukan');
      return;
    }
    if (startDate.value.isEmpty || endDate.value.isEmpty) {
      Get.snackbar('Error', 'Tanggal pinjam dan kembali harus diisi');
      return;
    }
    if (notes.value.isEmpty) {
      Get.snackbar('Error', 'Catatan wajib diisi');
      return;
    }
    if (photoPath.value.isEmpty) {
      Get.snackbar('Error', 'Foto kondisi barang wajib diisi');
      return;
    }

    try {
      isLoading.value = true;
      DateTime? start = DateTime.tryParse(startDate.value);
      DateTime? end = DateTime.tryParse(endDate.value);
      
      if (start == null || end == null) {
        Get.snackbar('Error', 'Format tanggal tidak valid');
        return;
      }

      final maxReturnDate = DateTime(start.year, start.month + 3, start.day);
      if (end.isAfter(maxReturnDate)) {
        Get.snackbar('Error', 'Tanggal kembali maksimal 3 bulan dari tanggal pinjam');
        return;
      }

      await LoansService.createLoan(
        itemId: item.id,
        loanDate: start,
        dueDate: end,
        note: notes.value,
        photoPath: photoPath.value.isNotEmpty ? photoPath.value : null,
      );

      Get.snackbar('Sukses', 'Permohonan pinjaman berhasil dibuat');
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', 'Gagal membuat permohonan pinjaman');
    } finally {
      isLoading.value = false;
    }
  }
}
