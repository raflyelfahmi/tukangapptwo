import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/painter_controller.dart';

class PainterView extends GetView<PainterController> {
  const PainterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PainterView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PainterView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
