import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notifications_controller.dart';
import '../../../theme/app_theme.dart';
import '../../../data/notification_model.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Notifikasi Sesi',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          Obx(() {
            final hasUnread = controller.unreadCount.value > 0;
            return TextButton(
              onPressed: hasUnread ? () => controller.markAllAsRead() : null,
              child: Text(
                'Tandai Dibaca',
                style: TextStyle(
                  color: hasUnread ? AppColors.primary : AppColors.textHint,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            );
          }),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.notifications.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.divider, width: 1.5),
                    ),
                    child: const Icon(
                      Icons.notifications_off_rounded,
                      size: 48,
                      color: AppColors.textHint,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Belum Ada Notifikasi',
                    style: AppTextStyles.subtitle.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Riwayat pemberitahuan status peminjaman barang Anda akan muncul di sini secara teratur.',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchNotifications(),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final notif = controller.notifications[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _NotificationCard(
                  notif: notif,
                  onTap: () {
                    if (!notif.isRead) {
                      controller.markAsRead(notif.id);
                    }
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notif;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notif,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color severityColor;
    IconData severityIcon;

    switch (notif.type.toLowerCase()) {
      case 'approved':
        severityColor = AppColors.statusAvailable;
        severityIcon = Icons.check_circle_outline_rounded;
        break;
      case 'rejected':
        severityColor = AppColors.statusOverdue;
        severityIcon = Icons.error_outline_rounded;
        break;
      case 'due_soon':
        severityColor = AppColors.statusPending;
        severityIcon = Icons.warning_amber_rounded;
        break;
      case 'overdue':
        severityColor = AppColors.statusOverdue;
        severityIcon = Icons.gavel_rounded;
        break;
      case 'returned':
        severityColor = AppColors.statusReturned;
        severityIcon = Icons.assignment_turned_in_rounded;
        break;
      default:
        severityColor = AppColors.primary;
        severityIcon = Icons.notifications_active_rounded;
    }

    final String formattedDate =
        '${notif.alertedAt.day}/${notif.alertedAt.month}/${notif.alertedAt.year} · ${notif.alertedAt.hour.toString().padLeft(2, '0')}:${notif.alertedAt.minute.toString().padLeft(2, '0')}';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: notif.isRead ? AppColors.surface : AppColors.surface.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: notif.isRead 
                ? AppColors.divider 
                : severityColor.withValues(alpha: 0.4),
            width: notif.isRead ? 1.0 : 1.5,
          ),
          boxShadow: notif.isRead 
              ? [] 
              : [
                  BoxShadow(
                    color: severityColor.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Icon Indicator
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: severityColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                severityIcon,
                color: severityColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            // Message Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        notif.type == 'approved'
                            ? 'Disetujui'
                            : notif.type == 'rejected'
                                ? 'Ditolak'
                                : notif.type == 'returned'
                                    ? 'Dikembalikan'
                                    : notif.type == 'due_soon'
                                        ? 'Tenggat Waktu'
                                        : notif.type == 'overdue'
                                            ? 'Terlambat'
                                            : 'Pemberitahuan',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: severityColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notif.message,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      fontWeight: notif.isRead ? FontWeight.w500 : FontWeight.w700,
                      color: notif.isRead ? AppColors.textSecondary : AppColors.textPrimary,
                    ),
                  ),
                  if (notif.loan?.item != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Barang: ${notif.loan!.item!.name}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
