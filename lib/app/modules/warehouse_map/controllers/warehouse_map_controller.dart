import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

/// Model for a warehouse location
class Warehouse {
  final String id;
  final String code;
  final String name;
  final String address;
  final LatLng position;

  const Warehouse({
    required this.id,
    required this.code,
    required this.name,
    required this.address,
    required this.position,
  });
}

class WarehouseMapController extends GetxController {
  late final MapController mapController;

  // Observable state
  final userPosition = Rxn<LatLng>();
  final selectedWarehouse = Rxn<Warehouse>();
  final isLoadingLocation = false.obs;
  final zoomLevel = 14.0.obs;

  // Dummy warehouse data (will be replaced by API later)
  final warehouses = <Warehouse>[
    const Warehouse(
      id: '1',
      code: 'WH-772_DELTA',
      name: 'Warehouse 772 Delta',
      address: 'Industrial District, Sector 4C',
      position: LatLng(-6.2088, 106.8456),
    ),
    const Warehouse(
      id: '2',
      code: 'WH-310_ALPHA',
      name: 'Warehouse 310 Alpha',
      address: 'Jl. Raya Bogor KM 20',
      position: LatLng(-6.2250, 106.8600),
    ),
    const Warehouse(
      id: '3',
      code: 'WH-105_BRAVO',
      name: 'Warehouse 105 Bravo',
      address: 'Kompleks Pergudangan Sunter',
      position: LatLng(-6.1900, 106.8700),
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    mapController = MapController();
    // Select the first warehouse by default
    selectedWarehouse.value = warehouses.first;
  }

  @override
  void onReady() {
    super.onReady();
    _getCurrentLocation();
  }

  @override
  void onClose() {
    mapController.dispose();
    super.onClose();
  }

  /// Request and get current user position
  Future<void> _getCurrentLocation() async {
    isLoadingLocation.value = true;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        userPosition.value = const LatLng(-6.2150, 106.8300);
        isLoadingLocation.value = false;
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          userPosition.value = const LatLng(-6.2150, 106.8300);
          isLoadingLocation.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        userPosition.value = const LatLng(-6.2150, 106.8300);
        isLoadingLocation.value = false;
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      userPosition.value = LatLng(position.latitude, position.longitude);
    } catch (e) {
      debugPrint('Location error: $e');
      userPosition.value = const LatLng(-6.2150, 106.8300);
    } finally {
      isLoadingLocation.value = false;
    }
  }

  /// Calculate distance between two points in km
  double distanceTo(LatLng from, LatLng to) {
    const Distance distance = Distance();
    return distance.as(LengthUnit.Kilometer, from, to);
  }

  /// Get distance string for selected warehouse
  String getDistanceString(Warehouse warehouse) {
    if (userPosition.value == null) return '—';
    final dist = distanceTo(userPosition.value!, warehouse.position);
    return dist.toStringAsFixed(1);
  }

  /// Estimated time in minutes (assume ~20 km/h avg)
  String getEstimatedTime(Warehouse warehouse) {
    if (userPosition.value == null) return '—';
    final dist = distanceTo(userPosition.value!, warehouse.position);
    final minutes = (dist / 20 * 60).round();
    return '$minutes';
  }

  /// Route integrity – simulated metric
  double getRouteIntegrity(Warehouse warehouse) {
    if (userPosition.value == null) return 95.0;
    final dist = distanceTo(userPosition.value!, warehouse.position);
    return max(85.0, 100.0 - dist * 1.5);
  }

  /// Select a warehouse
  void selectWarehouse(Warehouse warehouse) {
    selectedWarehouse.value = warehouse;
    mapController.move(warehouse.position, zoomLevel.value);
  }

  /// Center on user location
  void centerOnUser() {
    if (userPosition.value != null) {
      mapController.move(userPosition.value!, zoomLevel.value);
    }
  }

  /// Zoom in
  void zoomIn() {
    zoomLevel.value = min(18.0, zoomLevel.value + 1);
    mapController.move(mapController.camera.center, zoomLevel.value);
  }

  /// Zoom out
  void zoomOut() {
    zoomLevel.value = max(5.0, zoomLevel.value - 1);
    mapController.move(mapController.camera.center, zoomLevel.value);
  }

  /// Open in Google Maps with directions
  Future<void> navigateToGoogleMaps(Warehouse warehouse) async {
    final lat = warehouse.position.latitude;
    final lng = warehouse.position.longitude;
    final uri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Navigasi',
          'Membuka Google Maps ke ${warehouse.name}...',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFE53935),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal membuka Google Maps',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFE53935),
        colorText: Colors.white,
      );
    }
  }

  /// Show warehouse details
  void showWarehouseDetails(Warehouse warehouse) {
    Get.snackbar(
      warehouse.name,
      '${warehouse.address}\nKoordinat: ${warehouse.position.latitude}, ${warehouse.position.longitude}',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF1A1A2E),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}
