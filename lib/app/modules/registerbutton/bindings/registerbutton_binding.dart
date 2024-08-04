import 'package:get/get.dart';

import '../controllers/registerbutton_controller.dart';

class RegisterbuttonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterbuttonController>(
      () => RegisterbuttonController(),
    );
  }
}
