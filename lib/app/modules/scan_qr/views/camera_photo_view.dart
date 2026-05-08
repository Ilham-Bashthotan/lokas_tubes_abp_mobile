import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';
import '../controllers/scan_qr_controller.dart';

/// FR-13 — Camera / Foto Kondisi Barang
/// This is navigated to from LoanFormView & ReturnFormView
class CameraPhotoView extends GetView<ScanQrController> {
  const CameraPhotoView({super.key});

  @override
  Widget build(BuildContext context) {
    final photoTaken = false.obs;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: Colors.white,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Foto Kondisi Barang',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // ── Viewfinder ────────────────────────────────────
          Expanded(
            child: Stack(
              children: [
                // Camera preview placeholder
                Container(
                  width: double.infinity,
                  color: const Color(0xFF0A0A0A),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.07),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.photo_camera_rounded,
                          color: Colors.white38,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Preview Kamera',
                        style: TextStyle(color: Colors.white38, fontSize: 13),
                      ),
                    ],
                  ),
                ),

                // Corner brackets overlay
                Positioned.fill(
                  child: CustomPaint(painter: _CornerBracketPainter()),
                ),

                // Resolution hint
                Positioned(
                  top: 12,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Mode resolusi rendah aktif',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Controls ──────────────────────────────────────
          Container(
            color: const Color(0xFF111111),
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
            child: Column(
              children: [
                // Shutter row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Thumbnail / flash hint
                    Obx(
                      () => photoTaken.value
                          ? Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.primaryLight,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.primaryLight,
                                size: 24,
                              ),
                            )
                          : const SizedBox(width: 48),
                    ),

                    // Shutter button
                    GestureDetector(
                      onTap: () => photoTaken.value = true,
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryLight,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 18,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_rounded,
                              color: AppColors.primary,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Flip icon
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.flip_camera_android_rounded,
                        color: Colors.white54,
                        size: 28,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tap tombol untuk mengambil foto',
                  style: TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ],
            ),
          ),

          // ── Preview & Action ──────────────────────────────
          Obx(
            () => photoTaken.value
                ? Container(
                    color: AppColors.background,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Preview', style: AppTextStyles.label),
                        const SizedBox(height: 8),
                        Container(
                          height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.image_rounded,
                              color: AppColors.primary,
                              size: 40,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => photoTaken.value = false,
                                icon: const Icon(
                                  Icons.refresh_rounded,
                                  size: 16,
                                ),
                                label: const Text('Ulangi'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => Get.back(),
                                icon: const Icon(
                                  Icons.check_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                label: const Text('Gunakan Foto'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // Safe area bottom padding
          Container(
            color: photoTaken.value
                ? AppColors.background
                : const Color(0xFF111111),
            height: MediaQuery.of(context).padding.bottom,
          ),
        ],
      ),
    );
  }
}

class _CornerBracketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryLight
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const d = 36.0;
    const margin = 48.0;

    // Top-left
    canvas.drawLine(Offset(margin, margin + d), Offset(margin, margin), paint);
    canvas.drawLine(Offset(margin, margin), Offset(margin + d, margin), paint);

    // Top-right
    canvas.drawLine(
      Offset(size.width - margin - d, margin),
      Offset(size.width - margin, margin),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - margin, margin),
      Offset(size.width - margin, margin + d),
      paint,
    );

    // Bottom-left
    canvas.drawLine(
      Offset(margin, size.height - margin - d),
      Offset(margin, size.height - margin),
      paint,
    );
    canvas.drawLine(
      Offset(margin, size.height - margin),
      Offset(margin + d, size.height - margin),
      paint,
    );

    // Bottom-right
    canvas.drawLine(
      Offset(size.width - margin - d, size.height - margin),
      Offset(size.width - margin, size.height - margin),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - margin, size.height - margin),
      Offset(size.width - margin, size.height - margin - d),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
