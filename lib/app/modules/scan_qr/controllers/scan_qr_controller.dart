import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrController extends GetxController {
  final MobileScannerController scannerController = MobileScannerController();

  // Observable untuk hasil scan
  final scannedItem = Rx<Map<String, dynamic>?>(null);

  // Dummy data untuk simulasi
  final dummyItems = {
    'INV-2026-001': {
      'name': 'Laptop Dell XPS 13',
      'code': 'INV-2026-001',
      'status': 'Available',
      'category': 'Elektronik',
      'warehouse': 'Gudang A',
      'condition': 'Good'
    },
    'INV-2026-002': {
      'name': 'Proyektor Epson EB',
      'code': 'INV-2026-002',
      'status': 'Borrowed',
      'category': 'Elektronik',
      'warehouse': 'Gudang B',
      'condition': 'Good'
    },
    'INV-2026-003': {
      'name': 'Kamera Canon EOS',
      'code': 'INV-2026-003',
      'status': 'Available',
      'category': 'Kamera',
      'warehouse': 'Gudang A',
      'condition': 'Good'
    },
  };

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

  void onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final String? code = barcode.rawValue;
      if (code != null && code.isNotEmpty) {
        // Cari item berdasarkan kode QR
        final item = dummyItems[code];
        if (item != null) {
          scannedItem.value = item;
          // Stop scanning setelah berhasil
          scannerController.stop();
          break;
        }
      }
    }
  }

  void scanAgain() {
    scannedItem.value = null;
    scannerController.start();
  }

  void goToLoanForm() {
    if (scannedItem.value != null) {
      // Navigasi ke loan form dengan data item
      Get.toNamed('/loan-form', arguments: scannedItem.value);
    }
  }
}
