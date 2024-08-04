import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/konsultasiuser_controller.dart';

class KonsultasiuserView extends GetView<KonsultasiuserController> {
  const KonsultasiuserView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Konsultasi'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'UserkonsultasiView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}