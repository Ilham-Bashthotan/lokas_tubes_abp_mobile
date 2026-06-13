import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../widgets/app_bottom_nav.dart';
import '../controllers/scan_qr_controller.dart';

class ScanQrView extends GetView<ScanQrController> {
  const ScanQrView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        automaticallyImplyLeading: false,
        title: const Text('Scan QR Barang'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: cs.onSurface.withOpacity(0.08)),
        ),
      ),
      body: Column(
        children: [
          // Instruction text
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Arahkan kamera ke QR code barang',
              style: TextStyle(fontSize: 11, color: cs.onSurface.withOpacity(0.6)),
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
                color: cs.primary.withOpacity(0.3),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
              color: cs.surface,
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
              style: TextStyle(fontSize: 10, color: cs.onSurface.withOpacity(0.6)),
              textAlign: TextAlign.center,
            ),
          ),

          // Divider
          Container(
            height: 1,
            color: cs.onSurface.withOpacity(0.08),
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
                      color: cs.onSurface.withOpacity(0.7),
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
                          border: Border.all(color: cs.onSurface.withOpacity(0.08)),
                          color: cs.surface,
                        ),
                        child: Text(
                          'Belum ada hasil scan',
                          style: TextStyle(
                            fontSize: 12,
                            color: cs.onSurface.withOpacity(0.7),
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
                              ? cs.onSurface.withOpacity(0.08)
                              : Colors.redAccent.withOpacity(0.5),
                          width: isAvailable ? 1 : 1.5,
                        ),
                        color: isAvailable
                            ? cs.surface
                            : Colors.red.withOpacity(0.03),
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
                                    color: cs.onSurface,
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
                                  ? cs.onSurface.withOpacity(0.7)
                                  : Colors.redAccent.withOpacity(0.8),
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
                              backgroundColor: cs.primary,
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
                            side: BorderSide(color: cs.onSurface.withOpacity(0.12)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            foregroundColor: cs.onSurface,
                          ),
                          child: Text(
                            hasResult ? 'Scan Ulang' : 'Mulai Scan',
                            style: TextStyle(color: cs.onSurface),
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
