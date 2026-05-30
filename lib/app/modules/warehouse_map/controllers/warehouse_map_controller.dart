import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/warehouse_model.dart';
import '../../../data/warehouse_service.dart';

class WarehouseMapController extends GetxController {
  late final MapController mapController;

  // Observable state
  final userPosition = Rxn<LatLng>();
  final selectedWarehouse = Rxn<WarehouseLocation>();
  final warehouses = <WarehouseLocation>[].obs;
  final isLoadingLocation = false.obs;
  final isLoadingWarehouses = false.obs;
  final warehousesError = RxnString();
  final zoomLevel = 14.0.obs;

  @override
  void onInit() {
    super.onInit();
    mapController = MapController();
    loadWarehouses();
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

  Future<void> loadWarehouses() async {
    isLoadingWarehouses.value = true;
    warehousesError.value = null;

    try {
      final fetchedWarehouses = await WarehouseService.fetchWarehouses();
      warehouses.assignAll(fetchedWarehouses);
      if (warehouses.isNotEmpty) {
        selectedWarehouse.value = warehouses.first;
      }
    } catch (_) {
      warehousesError.value = 'Gagal memuat data gudang';
      warehouses.clear();
      selectedWarehouse.value = null;
    } finally {
      isLoadingWarehouses.value = false;
    }
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
    const distance = Distance();
    return distance.as(LengthUnit.Kilometer, from, to);
  }

  /// Get distance string for selected warehouse
  String getDistanceString(WarehouseLocation warehouse) {
    if (userPosition.value == null) return '—';
    final dist = distanceTo(userPosition.value!, warehouse.position);
    return dist.toStringAsFixed(1);
  }

  /// Estimated time in minutes (assume ~20 km/h avg)
  String getEstimatedTime(WarehouseLocation warehouse) {
    if (userPosition.value == null) return '—';
    final dist = distanceTo(userPosition.value!, warehouse.position);
    final minutes = (dist / 20 * 60).round();
    return '$minutes';
  }

  /// Route integrity – simulated metric
  double getRouteIntegrity(WarehouseLocation warehouse) {
    if (userPosition.value == null) return 95.0;
    final dist = distanceTo(userPosition.value!, warehouse.position);
    return dist > 10 ? 85.0 : 100.0 - dist * 1.5;
  }

  /// Select a warehouse
  void selectWarehouse(WarehouseLocation warehouse) {
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
  Future<void> navigateToGoogleMaps(WarehouseLocation warehouse) async {
    final lat = warehouse.position.latitude;
    final lng = warehouse.position.longitude;
    final encodedName = Uri.encodeComponent(warehouse.name);
    final primaryUri = defaultTargetPlatform == TargetPlatform.android
        ? Uri.parse('geo:$lat,$lng?q=$lat,$lng($encodedName)')
        : Uri.parse('comgooglemaps://?q=$lat,$lng&center=$lat,$lng&zoom=14');

    final fallbackUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
    );

    try {
      if (await launchUrl(primaryUri, mode: LaunchMode.externalApplication)) {
        return;
      }

      if (await launchUrl(fallbackUri, mode: LaunchMode.externalApplication)) {
        return;
      }
    } catch (e) {
      debugPrint('Gagal membuka Google Maps: $e');
    }
  }

  /// Show warehouse details
  void showWarehouseDetails(WarehouseLocation warehouse) {
    Get.snackbar(
      warehouse.name,
      '${warehouse.address}\nKoordinat: ${warehouse.latitude}, ${warehouse.longitude}',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF1A1A2E),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}
