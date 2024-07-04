import 'package:get/get.dart';

import '../controllers/painter_controller.dart';

class PainterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PainterController>(
      () => PainterController(),
    );
  }
}
