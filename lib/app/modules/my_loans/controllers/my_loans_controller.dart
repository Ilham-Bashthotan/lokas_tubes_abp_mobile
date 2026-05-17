import 'package:get/get.dart';
import '../../../data/loans_service.dart';
import '../../../data/loan_model.dart';

class MyLoansController extends GetxController {
  final loans = <Loan>[].obs;
  final isLoading = false.obs;
  final selectedStatus = 'all'.obs;

  // Persistent global counts for stats banner
  final totalCount = 0.obs;
  final activeCount = 0.obs;
  final pendingCount = 0.obs;
  final overdueCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLoans();
  }

  Future<void> fetchLoans() async {
    try {
      isLoading.value = true;
      final status = selectedStatus.value == 'all' ? null : selectedStatus.value;
      final result = await LoansService.fetchMyLoans(status: status);
      loans.assignAll(result.loans);

      // Update global stats only when fetching all loans to prevent stats from shrinking/zeroing when filtering
      if (selectedStatus.value == 'all') {
        totalCount.value = result.loans.length;
        activeCount.value = result.loans.where((l) => l.status == 'active' || l.status == 'borrowed').length;
        pendingCount.value = result.loans.where((l) => l.status == 'pending').length;
        overdueCount.value = result.loans.where((l) => l.status == 'overdue').length;
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat riwayat peminjaman');
    } finally {
      isLoading.value = false;
    }
  }

  void filterStatus(String status) {
    selectedStatus.value = status;
    fetchLoans();
  }
}
