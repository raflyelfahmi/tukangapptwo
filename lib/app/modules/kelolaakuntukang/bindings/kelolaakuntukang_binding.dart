import 'package:get/get.dart';

import '../controllers/kelolaakuntukang_controller.dart';

class KelolaakuntukangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KelolaakuntukangController>(
      () => KelolaakuntukangController(),
    );
  }
}
