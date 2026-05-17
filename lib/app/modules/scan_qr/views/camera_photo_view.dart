import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';

/// FR-13 — Camera / Foto Kondisi Barang
/// This is navigated to from LoanFormView & ReturnFormView
class CameraPhotoView extends StatefulWidget {
  const CameraPhotoView({super.key});

  @override
  State<CameraPhotoView> createState() => _CameraPhotoViewState();
}

class _CameraPhotoViewState extends State<CameraPhotoView> {
  List<CameraDescription> _cameras = [];
  CameraController? _cameraController;
  int _selectedCameraIndex = 0;
  bool _isCameraInitialized = false;
  bool _isCameraError = false;
  String _errorMessage = '';

  // Captured photo state
  String? _capturedImagePath;
  bool _isTakingPicture = false;

  @override
  void initState() {
    super.initState();
    _initializeCameras();
  }

  Future<void> _initializeCameras() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        await _initCameraController(_cameras[_selectedCameraIndex]);
      } else {
        setState(() {
          _isCameraError = true;
          _errorMessage =
              'Tidak ada kamera yang terdeteksi pada perangkat ini.';
        });
      }
    } catch (e) {
      setState(() {
        _isCameraError = true;
        _errorMessage = 'Gagal memuat daftar kamera: $e';
      });
    }
  }

  Future<void> _initCameraController(
    CameraDescription cameraDescription,
  ) async {
    setState(() {
      _isCameraInitialized = false;
    });

    if (_cameraController != null) {
      await _cameraController!.dispose();
    }

    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
          _isCameraError = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCameraError = true;
          _errorMessage = 'Gagal menginisialisasi kamera: $e';
        });
      }
    }
  }

  Future<void> _flipCamera() async {
    if (_cameras.isEmpty) return;
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    await _initCameraController(_cameras[_selectedCameraIndex]);
  }

  Future<void> _takePicture() async {
    if (_cameraController == null ||
        !_isCameraInitialized ||
        _cameraController!.value.isTakingPicture) {
      return;
    }

    try {
      setState(() {
        _isTakingPicture = true;
      });

      final XFile imageFile = await _cameraController!.takePicture();

      setState(() {
        _capturedImagePath = imageFile.path;
        _isTakingPicture = false;
      });
    } catch (e) {
      setState(() {
        _isTakingPicture = false;
      });
      Get.snackbar(
        'Gagal Mengambil Foto',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto =
        _capturedImagePath != null && _capturedImagePath!.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: Colors.white,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Ambil Foto Kondisi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Viewfinder / Preview
          Expanded(
            child: Stack(
              children: [
                // Render live camera feed OR captured image
                _buildViewfinderContent(hasPhoto),

                // Corner brackets overlay (Only show when NO photo is taken)
                if (!hasPhoto)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(painter: _CornerBracketPainter()),
                    ),
                  ),
                // Loader when taking picture
                if (_isTakingPicture)
                  Container(
                    color: Colors.black45,
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),

          // Bottom Panel / Controls
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            color: const Color(0xFF0F0F0F),
            padding: EdgeInsets.fromLTRB(
              24,
              20,
              24,
              16 + MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!hasPhoto) ...[
                  // Capture Controls Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Symmetrical spacer to center the Shutter button perfectly
                      const SizedBox(width: 46),

                      // Shutter button
                      GestureDetector(
                        onTap: _takePicture,
                        child: Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primaryLight,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.4),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.camera_alt_rounded,
                              color: AppColors.primary,
                              size: 32,
                            ),
                          ),
                        ),
                      ),

                      // Flip camera button
                      _RoundIconButton(
                        icon: Icons.flip_camera_android_rounded,
                        onPressed: _flipCamera,
                        tooltip: 'Putar Kamera',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Arahkan kamera ke barang dan ketuk tombol tengah',
                    style: TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                ] else ...[
                  // Confirmation Controls Row
                  Row(
                    children: [
                      // Retake button
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                _capturedImagePath = null;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white24),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(
                              Icons.refresh_rounded,
                              color: Colors.white70,
                              size: 18,
                            ),
                            label: const Text(
                              'Foto Ulang',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Confirm button
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                Get.back(result: _capturedImagePath),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            icon: const Icon(
                              Icons.check_circle_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            label: const Text(
                              'Gunakan Foto',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Pastikan foto kondisi barang terlihat jelas dan terang',
                    style: TextStyle(
                      color: AppColors.primaryLight.withValues(alpha: 0.8),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewfinderContent(bool hasPhoto) {
    if (hasPhoto) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Image.file(File(_capturedImagePath!), fit: BoxFit.cover),
      );
    }

    if (_isCameraError) {
      return Container(
        width: double.infinity,
        color: const Color(0xFF0D0D0D),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Colors.redAccent,
                size: 38,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Gagal Mengakses Kamera',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.white38, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _initializeCameras,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (!_isCameraInitialized || _cameraController == null) {
      return Container(
        width: double.infinity,
        color: const Color(0xFF0D0D0D),
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    // Render live camera feed with aspect ratio scale crop (BoxFit.cover equivalent)
    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * _cameraController!.value.aspectRatio;
    if (scale < 1) scale = 1 / scale;

    return ClipRect(
      child: Transform.scale(
        scale: scale,
        child: Center(child: CameraPreview(_cameraController!)),
      ),
    );
  }
}

// Helpers

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;

  const _RoundIconButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white70, size: 22),
        onPressed: onPressed,
        tooltip: tooltip,
        constraints: const BoxConstraints(minWidth: 46, minHeight: 46),
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
