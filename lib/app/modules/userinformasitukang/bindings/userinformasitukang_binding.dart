import 'package:get/get.dart';

import '../controllers/userinformasitukang_controller.dart';

class UserinformasitukangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserinformasitukangController>(
      () => UserinformasitukangController(),
    );
  }
}
