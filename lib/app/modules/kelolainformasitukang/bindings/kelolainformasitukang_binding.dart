import 'package:get/get.dart';

import '../controllers/kelolainformasitukang_controller.dart';

class KelolainformasitukangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KelolainformasitukangController>(
      () => KelolainformasitukangController(),
    );
  }
}
