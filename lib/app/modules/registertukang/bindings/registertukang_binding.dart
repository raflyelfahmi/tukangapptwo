import 'package:get/get.dart';

import '../controllers/registertukang_controller.dart';

class RegistertukangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegistertukangController>(
      () => RegistertukangController(),
    );
  }
}
