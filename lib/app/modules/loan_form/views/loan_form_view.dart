import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
            // Item Card
            Obx(() {
              final item = controller.itemData.value;
              final itemName = item?.name ?? 'Memuat...';
              final itemCode = item?.qrCode ?? 'INV-XXXX-XXX';
              final status = item?.status ?? 'Available';
              final condition = item?.condition ?? 'Good';
              final statusColor = status.toLowerCase() == 'available'
                  ? AppColors.statusAvailable
                  : AppColors.statusOverdue;

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
                            '$itemCode · ${status.toUpperCase()} · ${condition.toUpperCase()}',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                    _StatusChip(status.toUpperCase(), statusColor),
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),

            // Form
            _SectionLabel('Tanggal Pinjam (Hari Ini)'),
            Obx(() {
              final dateVal = controller.startDate.value;
              final displayVal = dateVal.isNotEmpty
                  ? DateFormat('dd MMMM yyyy').format(DateTime.parse(dateVal))
                  : DateFormat('dd MMMM yyyy').format(DateTime.now());
              return _DateField(
                value: displayVal,
                icon: Icons.calendar_today_rounded,
              );
            }),
            const SizedBox(height: 12),
            _SectionLabel('Tanggal Kembali (Maks 3 Bulan)'),
            Obx(() {
              final dateVal = controller.endDate.value;
              final displayVal = dateVal.isNotEmpty
                  ? DateFormat('dd MMMM yyyy').format(DateTime.parse(dateVal))
                  : 'Pilih Tanggal Kembali';
              return _DateField(
                value: displayVal,
                icon: Icons.event_rounded,
                onTap: () async {
                  final now = DateTime.now();
                  final initialDate = dateVal.isNotEmpty 
                      ? DateTime.parse(dateVal) 
                      : now.add(const Duration(days: 1));
                  final lastDate = DateTime(now.year, now.month + 3, now.day);

                  final picked = await showDatePicker(
                    context: context,
                    initialDate: initialDate.isAfter(lastDate) ? lastDate : initialDate,
                    firstDate: now,
                    lastDate: lastDate,
                  );
                  if (picked != null) {
                    controller.setEndDate(DateFormat('yyyy-MM-dd').format(picked));
                  }
                },
              );
            }),
            const SizedBox(height: 12),
            _SectionLabel('Catatan'),
            TextFormField(
              maxLines: 3,
              onChanged: controller.setNotes,
              decoration: const InputDecoration(
                hintText: 'Untuk keperluan rapat...',
              ),
            ),
            const SizedBox(height: 20),

            // Photo section
            _SectionLabel('Foto Kondisi Barang'),
            const SizedBox(height: 8),
            Obx(() {
              if (controller.photoPath.value.isNotEmpty) {
                return Stack(
                  children: [
                    Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        image: DecorationImage(
                          image: FileImage(File(controller.photoPath.value)),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
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
                return _PhotoPlaceholder(
                  onTap: () async {
                    final result = await Get.toNamed(Routes.CAMERA);
                    if (result is String && result.isNotEmpty) {
                      controller.setPhotoPath(result);
                    }
                  },
                  label: 'Tap untuk buka kamera',
                );
              }
            }),
            const SizedBox(height: 28),

            // Submit
            Obx(() {
              final isValid = controller.isValid;
              final isLoading = controller.isLoading.value;
              return ElevatedButton(
                onPressed: (isValid && !isLoading)
                    ? () => controller.submitLoanRequest()
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
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
                    : const Text(
                        'Kirim Pengajuan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
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

// Helpers
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
  final VoidCallback? onTap;
  const _DateField({
    required this.value,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isClickable = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: AppDecoration.inputField.copyWith(
          color: isClickable ? null : Colors.grey.shade100,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isClickable ? AppColors.primary : AppColors.textHint,
            ),
            const SizedBox(width: 10),
            Text(
              value,
              style: AppTextStyles.body.copyWith(
                color: isClickable ? null : AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            if (isClickable)
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: AppColors.textHint,
              )
            else
              const Icon(
                Icons.lock_outline_rounded,
                size: 16,
                color: AppColors.textHint,
              ),
          ],
        ),
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
            color: AppColors.primary.withValues(alpha: 0.3),
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
