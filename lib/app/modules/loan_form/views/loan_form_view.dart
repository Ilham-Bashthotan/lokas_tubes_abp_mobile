import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';
import '../../../routes/app_pages.dart';
import '../controllers/loan_form_controller.dart';

class LoanFormView extends GetView<LoanFormController> {
  const LoanFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: AppColors.primary,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text('Ajukan Peminjaman'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Item Card ─────────────────────────────────
            Container(
              decoration: AppDecoration.card,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.laptop_rounded,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Laptop Dell XPS 13',
                          style: AppTextStyles.subtitle,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'INV-2026-001 · Available · Good',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  _StatusChip('Available', AppColors.statusAvailable),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Form ──────────────────────────────────────
            _SectionLabel('Tanggal Pinjam'),
            _DateField(
              value: '09 April 2026',
              icon: Icons.calendar_today_rounded,
            ),
            const SizedBox(height: 12),
            _SectionLabel('Tanggal Kembali'),
            _DateField(value: '16 April 2026', icon: Icons.event_rounded),
            const SizedBox(height: 12),
            _SectionLabel('Catatan'),
            TextFormField(
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Untuk keperluan rapat...',
              ),
            ),
            const SizedBox(height: 20),

            // ── Photo section ─────────────────────────────
            _SectionLabel('Foto Kondisi Barang'),
            const SizedBox(height: 8),
            _PhotoPlaceholder(
              onTap: () => Get.toNamed(Routes.CAMERA),
              label: 'Tap untuk buka kamera',
            ),
            const SizedBox(height: 28),

            // ── Submit ────────────────────────────────────
            ElevatedButton(
              onPressed: () => Get.offAllNamed(Routes.MY_LOANS),
              child: const Text('Kirim Pengajuan'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Get.back(),
              child: const Text('Batal'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text.toUpperCase(), style: AppTextStyles.label),
    );
  }
}

class _DateField extends StatelessWidget {
  final String value;
  final IconData icon;
  const _DateField({required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecoration.inputField,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Text(value, style: AppTextStyles.body),
          const Spacer(),
          const Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: AppColors.textHint,
          ),
        ],
      ),
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  const _PhotoPlaceholder({required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.primarySurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusChip(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
