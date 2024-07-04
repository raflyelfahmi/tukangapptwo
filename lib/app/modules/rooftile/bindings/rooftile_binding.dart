import 'package:get/get.dart';

import '../controllers/rooftile_controller.dart';

class RooftileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RooftileController>(
      () => RooftileController(),
    );
  }
}
