import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_theme.dart';
import '../../../routes/app_pages.dart';
import '../controllers/return_form_controller.dart';

class ReturnFormView extends GetView<ReturnFormController> {
  const ReturnFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final conditions = ['good', 'damaged'];
    final conditionLabels = ['Good', 'Damaged'];
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
            Obx(() {
              final loan = controller.loanData.value;
              final itemName = loan?.item.name ?? 'Memuat data...';
              final loanDateStr = loan != null
                  ? DateFormat('dd MMM').format(loan.loanDate)
                  : '';
              final dueDateStr = loan != null
                  ? DateFormat('dd MMM yyyy').format(loan.dueDate)
                  : '';
              final subtitleText = loan != null
                  ? 'Dipinjam: $loanDateStr · Due: $dueDateStr'
                  : 'Mohon tunggu...';

              return Container(
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
                            itemName,
                            style: AppTextStyles.subtitle,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitleText,
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            // Kondisi section
            _SectionLabel('Kondisi Barang Saat Kembali'),
            const SizedBox(height: 10),
            Obx(
              () => Row(
                children: List.generate(conditions.length, (i) {
                  final condValue = conditions[i];
                  final active = controller.conditionAfter.value == condValue;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: i == 0 ? 8 : 0),
                      child: GestureDetector(
                        onTap: () => controller.setCondition(condValue),
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
                                conditionLabels[i],
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
            Obx(() {
              if (controller.photoPath.value.isNotEmpty) {
                return Stack(
                  children: [
                    Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(File(controller.photoPath.value)),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: AppColors.statusActive.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => controller.setPhotoPath(''),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () async {
                          final result = await Get.toNamed(Routes.CAMERA);
                          if (result is String && result.isNotEmpty) {
                            controller.setPhotoPath(result);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Ubah Foto',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return GestureDetector(
                  onTap: () async {
                    final result = await Get.toNamed(Routes.CAMERA);
                    if (result is String && result.isNotEmpty) {
                      controller.setPhotoPath(result);
                    }
                  },
                  child: Container(
                    height: 110,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
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
                );
              }
            }),
            const SizedBox(height: 20),

            // Notes
            _SectionLabel('Catatan (opsional)'),
            TextFormField(
              maxLines: 3,
              onChanged: controller.setNote,
              decoration: const InputDecoration(
                hintText: 'Terdapat lecetan kecil di sudut...',
              ),
            ),
            const SizedBox(height: 32),

            // Confirm button
            Obx(() {
              final isValid = controller.isValid;
              final isLoading = controller.isLoading.value;
              return ElevatedButton(
                onPressed: (isValid && !isLoading)
                    ? () => controller.submitReturn()
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.statusReturned,
                  disabledBackgroundColor: Colors.grey.shade300,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Row(
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
              );
            }),
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
