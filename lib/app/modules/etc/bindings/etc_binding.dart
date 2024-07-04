import 'package:get/get.dart';

import '../controllers/etc_controller.dart';

class EtcBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EtcController>(
      () => EtcController(),
    );
  }
}
