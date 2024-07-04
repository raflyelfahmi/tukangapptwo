import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/etc_controller.dart';

class EtcView extends GetView<EtcController> {
  const EtcView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EtcView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'EtcView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
