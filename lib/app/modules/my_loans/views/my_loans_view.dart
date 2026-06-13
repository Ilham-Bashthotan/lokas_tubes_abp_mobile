import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_theme.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/app_bottom_nav.dart';
import '../controllers/my_loans_controller.dart';

class MyLoansView extends GetView<MyLoansController> {
  const MyLoansView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final activeFilter = 0.obs;
    final filters = ['Semua', 'Active', 'Pending', 'Returned'];

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        automaticallyImplyLeading: false,
        title: const Text('Riwayat Pinjam'),
        actions: [
          IconButton(
            icon: Icon(Icons.tune_rounded, color: cs.primary),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: cs.onSurface.withOpacity(0.08)),
        ),
      ),
      body: Column(
        children: [
          // Stats banner
          Obx(() {
            final total = controller.totalCount.value;
            final active = controller.activeCount.value;
            final pending = controller.pendingCount.value;
            final overdue = controller.overdueCount.value;

            return Container(
              color: cs.surface,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  _StatBox(label: 'Total', value: total.toString(), color: cs.primary),
                  const SizedBox(width: 10),
                  _StatBox(
                    label: 'Aktif',
                    value: active.toString(),
                    color: AppColors.statusActive,
                  ),
                  const SizedBox(width: 10),
                  _StatBox(
                    label: 'Pending',
                    value: pending.toString(),
                    color: AppColors.statusPending,
                  ),
                  const SizedBox(width: 10),
                  _StatBox(
                    label: 'Overdue',
                    value: overdue.toString(),
                    color: AppColors.statusOverdue,
                  ),
                ],
              ),
            );
          }),
          // Filter chips
          Container(
            color: cs.surface,
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
                        onTap: () {
                          activeFilter.value = i;
                          final statusMap = ['all', 'active', 'pending', 'returned'];
                          controller.filterStatus(statusMap[i]);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(height: 1, color: cs.onSurface.withOpacity(0.08)),
          // List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.loans.isEmpty) {
                return Center(
                  child: Text(
                    'Tidak ada data peminjaman',
                    style: TextStyle(color: cs.onSurface.withOpacity(0.7)),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.loans.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final realLoan = controller.loans[i];
                  
                  final statusStr = realLoan.status;
                  Color statusColor = AppColors.statusPending;
                  if (statusStr == 'active' || statusStr == 'borrowed') {
                    statusColor = AppColors.statusActive;
                  } else if (statusStr == 'returned') {
                    statusColor = AppColors.statusReturned;
                  } else if (statusStr == 'overdue') {
                    statusColor = AppColors.statusOverdue;
                  }

                  IconData loanIcon = Icons.laptop_rounded;
                  final itemNameLower = realLoan.item.name.toLowerCase();
                  if (itemNameLower.contains('proyektor') || itemNameLower.contains('projector')) {
                    loanIcon = Icons.screenshot_monitor_rounded;
                  } else if (itemNameLower.contains('kamera') || itemNameLower.contains('camera')) {
                    loanIcon = Icons.camera_alt_rounded;
                  } else if (itemNameLower.contains('mic') || itemNameLower.contains('micro')) {
                    loanIcon = Icons.mic_rounded;
                  }

                  final loanDateStr = DateFormat('dd MMM').format(realLoan.loanDate);
                  final dueDateStr = DateFormat('dd MMM yyyy').format(realLoan.dueDate);
                  final periodStr = '$loanDateStr – $dueDateStr';

                  final canReturn = statusStr == 'active' || statusStr == 'overdue' || statusStr == 'borrowed';

                  final displayItem = _LoanItem(
                    name: realLoan.item.name,
                    period: periodStr,
                    status: statusStr.toUpperCase(),
                    statusColor: statusColor,
                    icon: loanIcon,
                    canReturn: canReturn,
                  );

                  return _LoanCard(
                    loan: displayItem,
                    onReturnPressed: () {
                      Get.toNamed(Routes.RETURN_FORM, arguments: realLoan);
                    },
                  );
                },
              );
            }),
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
    final cs = Theme.of(context).colorScheme;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2)),
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
              style: TextStyle(
                fontSize: 10,
                color: cs.onSurface.withOpacity(0.7),
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
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: active ? cs.primary : cs.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active ? cs.primary : cs.onSurface.withOpacity(0.12),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            color: active ? Colors.white : cs.onSurface.withOpacity(0.75),
          ),
        ),
      ),
    );
  }
}

class _LoanCard extends StatelessWidget {
  final _LoanItem loan;
  final VoidCallback onReturnPressed;
  const _LoanCard({
    required this.loan,
    required this.onReturnPressed,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.onSurface.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: cs.onSurface.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
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
                  color: loan.statusColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(loan.icon, color: loan.statusColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(loan.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: cs.onSurface, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(loan.period,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: cs.onSurface.withOpacity(0.75))),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: loan.statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: loan.statusColor.withOpacity(0.3),
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
            Container(height: 1, color: cs.onSurface.withOpacity(0.08)),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onReturnPressed,
                icon: const Icon(Icons.assignment_return_rounded, size: 16),
                label: const Text('Kembalikan Barang'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: BorderSide(color: cs.primary),
                  foregroundColor: cs.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
