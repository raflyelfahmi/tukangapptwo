import 'package:get/get.dart';

import '../controllers/historytukang_controller.dart';

class HistorytukangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistorytukangController>(
      () => HistorytukangController(),
    );
  }
}
