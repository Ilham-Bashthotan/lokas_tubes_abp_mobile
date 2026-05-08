import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/warehouse_map_controller.dart';

class WarehouseMapView extends GetView<WarehouseMapController> {
  const WarehouseMapView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WarehouseMapView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'WarehouseMapView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
