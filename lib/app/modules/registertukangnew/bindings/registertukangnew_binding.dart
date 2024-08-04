import 'package:get/get.dart';

import '../controllers/registertukangnew_controller.dart';

class RegistertukangnewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegistertukangnewController>(
      () => RegistertukangnewController(),
    );
  }
}
