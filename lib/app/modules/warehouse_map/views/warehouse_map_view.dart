import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';

import '../../../theme/app_theme.dart';
import '../controllers/warehouse_map_controller.dart';

class WarehouseMapView extends GetView<WarehouseMapController> {
  const WarehouseMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.surface,
            expandedHeight: 60,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: AppColors.primary,
              ),
              onPressed: () => Get.back(),
            ),
            title: const Text('Lokasi Gudang'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, color: AppColors.divider),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + subtitle
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.map_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Lokasi Gudang', style: AppTextStyles.title),
                            SizedBox(height: 2),
                            Text(
                              'Peta interaktif gudang penyimpanan',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Map Container
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        // Map
                        _buildMap(),

                        // Zoom controls
                        Positioned(
                          right: 10,
                          top: 10,
                          child: Column(
                            children: [
                              _MapBtn(
                                icon: Icons.add,
                                onTap: controller.zoomIn,
                              ),
                              const SizedBox(height: 4),
                              _MapBtn(
                                icon: Icons.remove,
                                onTap: controller.zoomOut,
                              ),
                              const SizedBox(height: 8),
                              _MapBtn(
                                icon: Icons.my_location_rounded,
                                onTap: controller.centerOnUser,
                                isPrimary: true,
                              ),
                            ],
                          ),
                        ),

                        // Loading indicator
                        Obx(() {
                          if (controller.isLoadingLocation.value) {
                            return Positioned(
                              left: 10,
                              top: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Mencari lokasi...',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Stats Row
                  Obx(() {
                    final user = controller.userPosition.value;
                    return Row(
                      children: [
                        _StatBox(
                          label: 'Gudang',
                          value: '${controller.warehouses.length}',
                          icon: Icons.warehouse_rounded,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 10),
                        _StatBox(
                          label: 'Terdekat',
                          value: user != null
                              ? '${controller.getDistanceString(controller.warehouses.first)} km'
                              : '— km',
                          icon: Icons.near_me_rounded,
                          color: AppColors.statusPending,
                        ),
                        const SizedBox(width: 10),
                        _StatBox(
                          label: 'Posisi',
                          value: user != null ? 'Aktif' : 'Off',
                          icon: Icons.gps_fixed_rounded,
                          color: user != null
                              ? AppColors.statusAvailable
                              : AppColors.statusOverdue,
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 20),

                  // Warehouse List Section
                  const Text('Daftar Gudang', style: AppTextStyles.subtitle),
                  const SizedBox(height: 10),

                  // Warehouse cards
                  ...controller.warehouses.map(
                    (wh) => Obx(
                      () => _WarehouseCard(
                        warehouse: wh,
                        isSelected:
                            controller.selectedWarehouse.value?.id == wh.id,
                        distance: controller.getDistanceString(wh),
                        onTap: () => controller.selectWarehouse(wh),
                        onNavigate: () => controller.navigateToGoogleMaps(wh),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  MAP WIDGET
  // ═══════════════════════════════════════════════════════════
  Widget _buildMap() {
    return Obx(() {
      final user = controller.userPosition.value;

      return FlutterMap(
        mapController: controller.mapController,
        options: MapOptions(
          initialCenter: controller.warehouses.first.position,
          initialZoom: controller.zoomLevel.value,
          backgroundColor: AppColors.background,
        ),
        children: [
          // Tile layer (standard OpenStreetMap)
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.lokas.inventorytrack',
          ),

          // Warehouse markers
          MarkerLayer(
            markers: controller.warehouses.map((w) {
              final isSelected = controller.selectedWarehouse.value?.id == w.id;
              return Marker(
                point: w.position,
                width: isSelected ? 90 : 70,
                height: isSelected ? 55 : 40,
                child: GestureDetector(
                  onTap: () => controller.selectWarehouse(w),
                  child: _WarehouseMarker(code: w.code, isSelected: isSelected),
                ),
              );
            }).toList(),
          ),

          // User position
          if (user != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: user,
                  width: 40,
                  height: 40,
                  child: const _UserDot(),
                ),
              ],
            ),
        ],
      );
    });
  }
}

// ═══════════════════════════════════════════════════════════════
//  HELPER WIDGETS
// ═══════════════════════════════════════════════════════════════

/// Stat box (same style as Home page)
class _StatBox extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;

  const _StatBox({
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
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
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

/// Map zoom/location control button
class _MapBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  const _MapBtn({
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isPrimary ? AppColors.primary : AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: isPrimary ? Colors.white : AppColors.textPrimary,
          size: 18,
        ),
      ),
    );
  }
}

/// Warehouse marker on map
class _WarehouseMarker extends StatelessWidget {
  final String code;
  final bool isSelected;

  const _WarehouseMarker({required this.code, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isSelected ? 36 : 28,
          height: isSelected ? 36 : 28,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.primaryLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: isSelected ? 10 : 4,
                spreadRadius: isSelected ? 1 : 0,
              ),
            ],
          ),
          child: Icon(
            Icons.warehouse_rounded,
            color: Colors.white,
            size: isSelected ? 18 : 14,
          ),
        ),
        if (isSelected) ...[
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              code,
              style: const TextStyle(
                fontSize: 7,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// User position dot (blue pulsing)
class _UserDot extends StatefulWidget {
  const _UserDot();

  @override
  State<_UserDot> createState() => _UserDotState();
}

class _UserDotState extends State<_UserDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        final scale = 1.0 + _anim.value * 0.3;
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow
            Transform.scale(
              scale: scale,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.15),
                ),
              ),
            ),
            // Inner ring
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.2),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
            ),
            // Core dot
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Warehouse card in the list
class _WarehouseCard extends StatelessWidget {
  final Warehouse warehouse;
  final bool isSelected;
  final String distance;
  final VoidCallback onTap;
  final VoidCallback onNavigate;

  const _WarehouseCard({
    required this.warehouse,
    required this.isSelected,
    required this.distance,
    required this.onTap,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.5)
                : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.08)
                  : AppColors.primary.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.12)
                        : AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.warehouse_rounded,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.primaryLight,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(warehouse.name, style: AppTextStyles.subtitle),
                      const SizedBox(height: 2),
                      Text(warehouse.address, style: AppTextStyles.caption),
                    ],
                  ),
                ),
                // Distance badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    '$distance km',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Navigate button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onNavigate,
                icon: const Icon(Icons.navigation_rounded, size: 16),
                label: const Text('Buka di Google Maps'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.border),
                  minimumSize: const Size(0, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
