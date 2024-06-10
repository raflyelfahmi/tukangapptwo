import 'package:get/get.dart';

import '../controllers/welcomescreenuser_controller.dart';

class WelcomescreenuserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WelcomescreenuserController>(
      () => WelcomescreenuserController(),
    );
  }
}
