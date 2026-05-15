import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/app_bottom_nav.dart';
import '../controllers/my_loans_controller.dart';

class MyLoansView extends GetView<MyLoansController> {
  const MyLoansView({super.key});

  @override
  Widget build(BuildContext context) {
    final activeFilter = 0.obs;
    final filters = ['Semua', 'Active', 'Pending', 'Returned'];

    final loans = [
      _LoanItem(
        name: 'Laptop Dell XPS 13',
        period: '01 Apr – 08 Apr 2026',
        status: 'Overdue',
        statusColor: AppColors.statusOverdue,
        icon: Icons.laptop_rounded,
        canReturn: true,
      ),
      _LoanItem(
        name: 'Proyektor Epson',
        period: '05 Apr – 12 Apr 2026',
        status: 'Active',
        statusColor: AppColors.statusActive,
        icon: Icons.screenshot_monitor_rounded,
        canReturn: true,
      ),
      _LoanItem(
        name: 'Mic Wireless Shure',
        period: '01 Mar – 07 Mar 2026',
        status: 'Returned',
        statusColor: AppColors.statusReturned,
        icon: Icons.mic_rounded,
        canReturn: false,
      ),
      _LoanItem(
        name: 'Kamera Canon EOS',
        period: '07 Apr – 14 Apr 2026',
        status: 'Pending',
        statusColor: AppColors.statusPending,
        icon: Icons.camera_alt_rounded,
        canReturn: false,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        automaticallyImplyLeading: false,
        title: const Text('Riwayat Pinjam'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: Column(
        children: [
          // Stats banner
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                _StatBox(label: 'Total', value: '8', color: AppColors.primary),
                const SizedBox(width: 10),
                _StatBox(
                  label: 'Aktif',
                  value: '2',
                  color: AppColors.statusActive,
                ),
                const SizedBox(width: 10),
                _StatBox(
                  label: 'Pending',
                  value: '1',
                  color: AppColors.statusPending,
                ),
                const SizedBox(width: 10),
                _StatBox(
                  label: 'Overdue',
                  value: '1',
                  color: AppColors.statusOverdue,
                ),
              ],
            ),
          ),
          // Filter chips
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    filters.length,
                    (i) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _FilterChip(
                        label: filters[i],
                        active: activeFilter.value == i,
                        onTap: () => activeFilter.value = i,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(height: 1, color: AppColors.divider),
          // List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: loans.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _LoanCard(loan: loans[i]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
    );
  }
}

class _LoanItem {
  final String name, period, status;
  final Color statusColor;
  final IconData icon;
  final bool canReturn;
  const _LoanItem({
    required this.name,
    required this.period,
    required this.status,
    required this.statusColor,
    required this.icon,
    required this.canReturn,
  });
}

class _StatBox extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            color: active ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _LoanCard extends StatelessWidget {
  final _LoanItem loan;
  const _LoanCard({required this.loan});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecoration.card,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: loan.statusColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(loan.icon, color: loan.statusColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(loan.name, style: AppTextStyles.subtitle),
                    const SizedBox(height: 2),
                    Text(loan.period, style: AppTextStyles.caption),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: loan.statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: loan.statusColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  loan.status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: loan.statusColor,
                  ),
                ),
              ),
            ],
          ),
          if (loan.canReturn) ...[
            const SizedBox(height: 12),
            Container(height: 1, color: AppColors.divider),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Get.toNamed(Routes.RETURN_FORM),
                icon: const Icon(Icons.assignment_return_rounded, size: 16),
                label: const Text('Kembalikan Barang'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
