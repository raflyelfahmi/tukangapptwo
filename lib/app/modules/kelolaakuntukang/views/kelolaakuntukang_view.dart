import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tukangapptwo/app/modules/kelolainformasitukang/views/kelolainformasitukang_view.dart';
import 'package:tukangapptwo/app/modules/tu_edittim/views/tu_edittim_view.dart';
import 'package:tukangapptwo/app/modules/tu_tanggaltersedia/views/tu_tanggaltersedia_view.dart';

import '../controllers/kelolaakuntukang_controller.dart';

class KelolaakuntukangView extends GetView<KelolaakuntukangController> {
  const KelolaakuntukangView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Akun Tukang'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text('Kelola Role Tukang'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Get.to(() => const KelolainformasitukangView());
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Tanggal Ketersediaan'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Get.to(() => const TuTanggaltersediaView());
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Edit Tim Tukang'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Get.to(() => const TuEdittimView());
            },
          ),
        ],
      ),
    );
  }
}
