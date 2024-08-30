import 'package:get/get.dart';

import '../controllers/detailcekorder_controller.dart';

class DetailcekorderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailcekorderController>(
      () => DetailcekorderController(),
    );
  }
}
