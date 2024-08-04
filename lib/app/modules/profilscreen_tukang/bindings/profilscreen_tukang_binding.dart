import 'package:get/get.dart';

import '../controllers/profilscreen_tukang_controller.dart';

class ProfilscreenTukangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilscreenTukangController>(
      () => ProfilscreenTukangController(),
    );
  }
}
