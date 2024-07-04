import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/ceramist_controller.dart';

class CeramistView extends GetView<CeramistController> {
  const CeramistView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CeramistView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CeramistView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
