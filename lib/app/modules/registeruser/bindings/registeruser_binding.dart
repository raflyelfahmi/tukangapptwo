import 'package:get/get.dart';

import '../controllers/registeruser_controller.dart';

class RegisteruserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisteruserController>(
      () => RegisteruserController(),
    );
  }
}
