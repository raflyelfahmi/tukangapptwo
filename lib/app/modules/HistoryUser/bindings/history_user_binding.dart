import 'package:get/get.dart';

import '../controllers/history_user_controller.dart';

class HistoryUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryUserController>(
      () => HistoryUserController(),
    );
  }
}
