import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/item_model.dart';
import '../../../data/loan_model.dart';
import '../../../theme/app_theme.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/app_bottom_nav.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ───────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.surface,
            expandedHeight: 60,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: const Text(
              'LOKAS',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 22,
                letterSpacing: -1,
              ),
            ),
            actions: [
              Obx(() {
                final unread = controller.unreadCount.value;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        size: 24,
                      ),
                      onPressed: () => Get.toNamed(Routes.NOTIFICATIONS),
                    ),
                    if (unread > 0)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: const BoxDecoration(
                            color: AppColors.statusOverdue,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Center(
                            child: Text(
                              unread > 99 ? '99+' : '$unread',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }),
              const SizedBox(width: 8),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, color: AppColors.divider),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Stats Row ────────────────────────────────
                  Obx(
                    () => Row(
                      children: [
                        _StatCard(
                          label: 'Pinjaman Aktif',
                          value: controller.activeLoansCount.value.toString(),
                          icon: Icons.inventory_2_rounded,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 10),
                        _StatCard(
                          label: 'Menunggu',
                          value: controller.pendingLoansCount.value.toString(),
                          icon: Icons.hourglass_top_rounded,
                          color: AppColors.statusPending,
                        ),
                        const SizedBox(width: 10),
                        _StatCard(
                          label: 'Riwayat',
                          value: controller.totalLoansCount.value.toString(),
                          icon: Icons.history_rounded,
                          color: AppColors.statusReturned,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Quick Actions ─────────────────────────────
                  Container(
                    decoration: AppDecoration.primaryCard,
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Scan Barang',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Scan QR code untuk pinjam',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 14),
                              ElevatedButton.icon(
                                onPressed: () => Get.toNamed(Routes.SCAN_QR),
                                icon: const Icon(
                                  Icons.qr_code_scanner_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'Buka Scanner',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                                style:
                                    ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      minimumSize: const Size(0, 38),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: const BorderSide(
                                          color: Colors.white,
                                          width: 1.5,
                                        ),
                                      ),
                                      elevation: 0,
                                    ).copyWith(
                                      backgroundColor:
                                          WidgetStateProperty.resolveWith(
                                            (states) => Colors.white.withValues(
                                              alpha: 0.1,
                                            ),
                                          ),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.qr_code_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Pinjaman Saya ──────────────────────────────
                  _SectionHeader(
                    title: 'Pinjaman Saya',
                    onMore: () => Get.toNamed(Routes.MY_LOANS),
                  ),
                  Obx(() {
                    if (controller.myLoans.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Belum ada pinjaman.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      );
                    }
                    return Column(
                      children: controller.myLoans.map((loan) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _LoanCard(loan: loan),
                        );
                      }).toList(),
                    );
                  }),
                  const SizedBox(height: 20),

                  // ── Available Items ───────────────────────────
                  _SectionHeader(
                    title: 'Barang Tersedia',
                    onMore: () => Get.toNamed(Routes.ITEMS),
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (controller.availableItems.isEmpty) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: const Text(
                          'Tidak ada barang tersedia saat ini.',
                          style: TextStyle(color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    return Column(
                      children: controller.availableItems
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _AvailableItemCard(item: item),
                            ),
                          )
                          .toList(),
                    );
                  }),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.20)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onMore;
  const _SectionHeader({required this.title, required this.onMore});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: AppTextStyles.subtitle)),
        TextButton(
          onPressed: onMore,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
          ),
          child: const Text(
            'Lihat semua',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _LoanCard extends StatelessWidget {
  final Loan loan;
  const _LoanCard({required this.loan});

  @override
  Widget build(BuildContext context) {
    final isPending = loan.status == 'pending';

    // Konfigurasi warna, teks status, dan lencana berdasarkan status pinjaman
    Color color;
    String subtitle;
    Widget statusBadge;

    if (isPending) {
      color = AppColors.statusPending;
      subtitle = 'Menunggu persetujuan';
      statusBadge = Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Text(
          'Menunggu',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      );
    } else {
      final daysLeft = loan.dueDate.difference(DateTime.now()).inDays;
      final isUrgent = daysLeft <= 3;
      color = isUrgent ? AppColors.statusOverdue : AppColors.statusActive;
      subtitle =
          'Due: ${loan.dueDate.day}/${loan.dueDate.month}/${loan.dueDate.year}';
      statusBadge = Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Text(
          '${daysLeft < 0 ? 0 : daysLeft} hr',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      );
    }

    return Container(
      decoration: AppDecoration.card,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isPending
                  ? AppColors.statusPending.withValues(alpha: 0.1)
                  : AppColors.primarySurface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isPending
                  ? Icons.hourglass_empty_rounded
                  : Icons.inventory_rounded,
              color: isPending ? AppColors.statusPending : AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(loan.item.name, style: AppTextStyles.subtitle),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
          statusBadge,
        ],
      ),
    );
  }
}

class _AvailableItemCard extends StatelessWidget {
  final Item item;
  const _AvailableItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.ITEM_DETAIL, arguments: item.id),
      child: Container(
        decoration: AppDecoration.card,
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.statusAvailable.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                item.status == 'available'
                    ? Icons.inventory_2_rounded
                    : Icons.device_unknown_rounded,
                color: AppColors.statusAvailable,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: AppTextStyles.subtitle),
                  const SizedBox(height: 2),
                  Text(
                    '${item.warehouse?.name ?? 'Gudang'} · ${item.status.capitalizeFirst}',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.statusAvailable.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.statusAvailable.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                item.status.capitalizeFirst ?? item.status,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.statusAvailable,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
