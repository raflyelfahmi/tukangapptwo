import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/rooftile_controller.dart';

class RooftileView extends GetView<RooftileController> {
  const RooftileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RooftileView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'RooftileView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
