import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/item_detail_controller.dart';

class ItemDetailView extends GetView<ItemDetailController> {
  const ItemDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ItemDetailView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ItemDetailView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
