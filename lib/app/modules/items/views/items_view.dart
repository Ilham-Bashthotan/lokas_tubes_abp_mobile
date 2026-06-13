import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/item_model.dart';
import '../../../routes/app_pages.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/app_bottom_nav.dart';
import '../controllers/items_controller.dart';

bool _isDarkMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}

Color _statusAvailableColor(BuildContext context) {
  return _isDarkMode(context)
      ? AppColorsDark.statusAvailable
      : AppColors.statusAvailable;
}

Color _statusBorrowedColor(BuildContext context) {
  return _isDarkMode(context)
      ? AppColorsDark.statusBorrowed
      : AppColors.statusPending;
}

Color _statusMaintenanceColor(BuildContext context) {
  return _isDarkMode(context)
      ? AppColorsDark.statusOverdue
      : AppColors.statusOverdue;
}

Color _statusTextHintColor(BuildContext context) {
  return _isDarkMode(context)
      ? AppColorsDark.textHint
      : AppColors.textHint;
}

class ItemsView extends GetView<ItemsController> {
  const ItemsView({super.key});

  static const _statusOptions = [
    {'value': 'all', 'label': 'Semua'},
    {'value': 'available', 'label': 'Available'},
    {'value': 'borrowed', 'label': 'Borrowed'},
    {'value': 'maintenance', 'label': 'Maintenance'},
  ];

  Color _statusColor(String status, BuildContext context) {
    switch (status) {
      case 'available':
        return _statusAvailableColor(context);
      case 'borrowed':
        return _statusBorrowedColor(context);
      case 'maintenance':
        return _statusMaintenanceColor(context);
      default:
        return _statusTextHintColor(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        title: const Text('Daftar Barang'),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: cs.onSurface.withValues(alpha: 0.08)),
        ),
      ),
      body: SafeArea(
        child: Obx(
          () {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage.value != null) {
              return _ErrorState(
                message: controller.errorMessage.value!,
                onRefresh: controller.refresh,
              );
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: TextField(
                    onChanged: controller.onSearchChanged,
                    cursorColor: cs.primary,
                    decoration: InputDecoration(
                      hintText: 'Cari nama / QR code...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      filled: true,
                      fillColor: cs.surfaceContainerHighest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: cs.onSurface.withValues(alpha: 0.12)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: cs.onSurface.withValues(alpha: 0.12)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 42,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final option = _statusOptions[index];
                      final isSelected = controller.selectedStatus.value == option['value'];
                      return _FilterChip(
                        label: option['label']!,
                        active: isSelected,
                        onTap: () => controller.applyStatus(option['value']!),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemCount: _statusOptions.length,
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.refresh,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: controller.items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = controller.items[index];
                        return _ItemCard(
                          item: item,
                          statusColor: _statusColor(item.status, context),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRefresh;

  const _ErrorState({required this.message, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Terjadi kesalahan',
              style: AppTextStyles.subtitle.copyWith(color: cs.onSurface),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: cs.onSurface.withValues(alpha: 0.8)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRefresh,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: active ? cs.primary.withValues(alpha: 0.12) : cs.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: active ? cs.primary : cs.onSurface.withValues(alpha: 0.12),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: active ? FontWeight.w700 : FontWeight.w600,
            color: active ? cs.primary : cs.onSurface.withValues(alpha: 0.72),
          ),
        ),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final Item item;
  final Color statusColor;

  const _ItemCard({required this.item, required this.statusColor});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.ITEM_DETAIL, arguments: item.id),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.onSurface.withValues(alpha: 0.06)),
          boxShadow: [
            BoxShadow(
              color: cs.primary.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.inventory_2_rounded,
                color: statusColor,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: AppTextStyles.subtitle.copyWith(color: cs.onSurface),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.warehouse?.name ?? 'Gudang'} · ${item.status.capitalizeFirst}',
                    style: AppTextStyles.caption.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                item.status.capitalizeFirst ?? item.status,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
