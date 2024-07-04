import 'package:get/get.dart';

import '../controllers/profilscreen_controller.dart';

class ProfilscreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilscreenController>(
      () => ProfilscreenController(),
    );
  }
}
