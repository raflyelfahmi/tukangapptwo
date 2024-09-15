import 'package:get/get.dart';

import '../controllers/tu_edittim_controller.dart';

class TuEdittimBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TuEdittimController>(
      () => TuEdittimController(),
    );
  }
}
