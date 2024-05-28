import 'package:get/get.dart';

import '../controllers/buttonregister_controller.dart';

class ButtonregisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ButtonregisterController>(
      () => ButtonregisterController(),
    );
  }
}
