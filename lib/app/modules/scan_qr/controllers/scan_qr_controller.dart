import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../data/items_service.dart';
import '../../../data/item_model.dart';

class ScanQrController extends GetxController {
  final MobileScannerController scannerController = MobileScannerController();

  // Observable untuk hasil scan
  final scannedItem = Rx<Item?>(null);
  final isFetching = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    scannerController.dispose();
    super.onClose();
  }

  Future<void> onDetect(BarcodeCapture capture) async {
    if (isFetching.value || scannedItem.value != null) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final String? code = barcode.rawValue;
      if (code != null && code.isNotEmpty) {
        try {
          isFetching.value = true;
          errorMessage.value = '';
          scannerController.stop();

          final item = await ItemsService.fetchItemByQr(code);
          scannedItem.value = item;
          break;
        } catch (_) {
          errorMessage.value = 'Barang dengan QR tersebut tidak ditemukan';
          scannerController.start();
        } finally {
          isFetching.value = false;
        }
      }
    }
  }

  void scanAgain() {
    scannedItem.value = null;
    scannerController.start();
  }

  void goToLoanForm() {
    if (scannedItem.value != null &&
        scannedItem.value!.status.toLowerCase() == 'available') {
      // Navigasi ke loan form dengan data item
      Get.toNamed('/loan-form', arguments: scannedItem.value);
    }
  }
}
