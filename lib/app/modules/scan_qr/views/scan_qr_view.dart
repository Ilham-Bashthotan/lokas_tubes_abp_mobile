import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/app_bottom_nav.dart';
import '../controllers/scan_qr_controller.dart';

class ScanQrView extends GetView<ScanQrController> {
  const ScanQrView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        automaticallyImplyLeading: false,
        title: const Text('Scan QR Barang'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: Column(
        children: [
          // Instruction text
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Arahkan kamera ke QR code barang',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ),

          // QR Scanner Viewfinder
          Container(
            width: 260,
            height: 260,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
              color: AppColors.surface,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: MobileScanner(
                controller: controller.scannerController,
                onDetect: controller.onDetect,
              ),
            ),
          ),

          // Instruction text below viewfinder
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Pastikan QR code berada di dalam kotak',
              style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ),

          // Divider
          Container(
            height: 1,
            color: AppColors.divider,
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),

          // Scan Result Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hasil Scan:',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Result Card
                  Obx(() {
                    final item = controller.scannedItem.value;
                    if (item == null) {
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.divider),
                          color: AppColors.surface,
                        ),
                        child: Text(
                          'Belum ada hasil scan',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    }

                    final isAvailable =
                        item.status.toLowerCase() == 'available';

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isAvailable
                              ? AppColors.divider
                              : Colors.redAccent.withValues(alpha: 0.5),
                          width: isAvailable ? 1 : 1.5,
                        ),
                        color: isAvailable
                            ? AppColors.surface
                            : Colors.red.withValues(alpha: 0.03),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item.name,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              if (!isAvailable)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.redAccent.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Not Available',
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${item.qrCode} · Status: ${item.status}',
                            style: TextStyle(
                              fontSize: 11,
                              color: isAvailable
                                  ? AppColors.textSecondary
                                  : Colors.redAccent.withValues(alpha: 0.8),
                              fontWeight: isAvailable
                                  ? FontWeight.normal
                                  : FontWeight.w500,
                            ),
                          ),
                          if (!isAvailable) ...[
                            const SizedBox(height: 8),
                            const Divider(
                              color: Colors.redAccent,
                              thickness: 0.5,
                              height: 1,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: const [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.redAccent,
                                  size: 14,
                                ),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Barang tidak dapat dipinjam karena status tidak Available.',
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 16),

                  // Action Buttons
                  Obx(() {
                    final item = controller.scannedItem.value;
                    final hasResult = item != null;
                    final isAvailable =
                        hasResult && item.status.toLowerCase() == 'available';

                    return Column(
                      children: [
                        if (hasResult && isAvailable) ...[
                          ElevatedButton(
                            onPressed: controller.goToLoanForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            child: const Text('Ajukan Peminjaman'),
                          ),
                          const SizedBox(height: 6),
                        ],
                        OutlinedButton(
                          onPressed: controller.scanAgain,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 40),
                            side: BorderSide(color: AppColors.divider),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          child: Text(
                            hasResult ? 'Scan Ulang' : 'Mulai Scan',
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
    );
  }
}
