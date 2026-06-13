import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/app_theme.dart';
import '../../../routes/app_pages.dart';
import '../controllers/item_detail_controller.dart';

class ItemDetailView extends GetView<ItemDetailController> {
  const ItemDetailView({super.key});

  Color _statusColor(String status, ColorScheme cs) {
    switch (status) {
      case 'available':
        return AppColors.statusAvailable;
      case 'borrowed':
        return AppColors.statusPending;
      case 'maintenance':
        return AppColors.statusOverdue;
      default:
        return cs.onSurface.withOpacity(0.65);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: cs.primary,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text('Detail Barang'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: cs.onSurface.withOpacity(0.08)),
        ),
      ),
      backgroundColor: cs.background,
      body: SafeArea(
        child: Obx(
          () {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage.value != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Terjadi kesalahan', style: AppTextStyles.subtitle),
                      const SizedBox(height: 12),
                      Text(
                        controller.errorMessage.value!,
                        style: AppTextStyles.body,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: controller.loadItem,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final item = controller.item.value;
            if (item == null) {
              return Center(child: Text('Barang tidak ditemukan', style: TextStyle(color: cs.onSurface)));
            }

            final statusColor = _statusColor(item.status, cs);
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 220,
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: cs.onSurface.withOpacity(0.08)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                          ? Image.network(
                              item.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Center(
                                child: Icon(Icons.broken_image_rounded,
                                    size: 42, color: cs.onSurface.withOpacity(0.65)),
                              ),
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return const Center(child: CircularProgressIndicator());
                              },
                            )
                          : Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.image_outlined, size: 42, color: cs.onSurface.withOpacity(0.65)),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Foto barang tidak tersedia',
                                    style: TextStyle(color: cs.onSurface.withOpacity(0.65)),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: cs.onSurface,
                                      fontWeight: FontWeight.w700,
                                    )),
                            const SizedBox(height: 6),
                            Text(item.qrCode,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: cs.onSurface.withOpacity(0.7),
                                    )),
                          ],
                        ),
                      ),
                      _StatusChip(item.status.capitalizeFirst ?? item.status, statusColor),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (item.description != null && item.description!.isNotEmpty) ...[
                    Text('Deskripsi',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: cs.onSurface,
                              fontWeight: FontWeight.w700,
                            )),
                    const SizedBox(height: 8),
                    Text(item.description!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: cs.onSurface.withOpacity(0.85),
                            )),
                    const SizedBox(height: 18),
                  ],
                  _DetailRow(label: 'Kategori', value: item.category?.name ?? '-'),
                  const SizedBox(height: 10),
                  _DetailRow(label: 'Kondisi', value: item.condition.capitalizeFirst ?? item.condition),
                  const SizedBox(height: 10),
                  _DetailRow(label: 'Status', value: item.status.capitalizeFirst ?? item.status),
                  const SizedBox(height: 10),
                  _DetailRow(label: 'Gudang', value: item.warehouse?.name ?? '-'),
                  if (item.warehouse?.address != null) ...[
                    const SizedBox(height: 10),
                    _DetailRow(label: 'Alamat Gudang', value: item.warehouse!.address),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: item.status == 'available'
                        ? () => Get.toNamed(Routes.LOAN_FORM, arguments: item)
                        : null,
                    child: const Text('Ajukan Peminjaman'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: item.warehouse != null ? () => Get.toNamed(Routes.WAREHOUSE_MAP) : null,
                    child: const Text('Lihat Lokasi Gudang'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.onSurface.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: cs.onSurface.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.label),
                const SizedBox(height: 6),
                Text(value, style: AppTextStyles.body),
              ],
            ),
          ),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
