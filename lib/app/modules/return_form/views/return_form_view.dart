import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';
import '../../../routes/app_pages.dart';
import '../controllers/return_form_controller.dart';

class ReturnFormView extends GetView<ReturnFormController> {
  const ReturnFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedCondition = 0.obs; // 0=Good, 1=Damaged
    final conditions = ['Good', 'Damaged'];
    final conditionIcons = [
      Icons.check_circle_rounded,
      Icons.warning_amber_rounded,
    ];
    final conditionColors = [AppColors.statusReturned, AppColors.statusOverdue];

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
        title: const Text('Kembalikan Barang'),
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
            // Item Card
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
                          'Dipinjam: 01 Apr · Due: 08 Apr 2026',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Kondisi section
            _SectionLabel('Kondisi Barang Saat Kembali'),
            const SizedBox(height: 10),
            Obx(
              () => Row(
                children: List.generate(conditions.length, (i) {
                  final active = selectedCondition.value == i;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: i == 0 ? 8 : 0),
                      child: GestureDetector(
                        onTap: () => selectedCondition.value = i,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: active
                                ? conditionColors[i].withValues(alpha: 0.10)
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: active
                                  ? conditionColors[i]
                                  : AppColors.border,
                              width: active ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                conditionIcons[i],
                                color: active
                                    ? conditionColors[i]
                                    : AppColors.textHint,
                                size: 28,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                conditions[i],
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: active
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: active
                                      ? conditionColors[i]
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),

            // Photo section
            _SectionLabel('Foto Kondisi Saat Kembali'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => Get.toNamed(Routes.CAMERA),
              child: Container(
                height: 110,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.statusActive.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.statusActive.withValues(alpha: 0.3),
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
                        size: 26,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap untuk buka kamera',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Notes
            _SectionLabel('Catatan (opsional)'),
            TextFormField(
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Terdapat lecetan kecil di sudut...',
              ),
            ),
            const SizedBox(height: 32),

            // Confirm button
            ElevatedButton(
              onPressed: () => Get.offAllNamed(Routes.MY_LOANS),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.statusReturned,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Konfirmasi Pengembalian',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
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

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(), style: AppTextStyles.label);
  }
}
