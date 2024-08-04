import 'package:get/get.dart';

import '../controllers/ratingulasan_controller.dart';

class RatingulasanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RatingulasanController>(
      () => RatingulasanController(),
    );
  }
}
