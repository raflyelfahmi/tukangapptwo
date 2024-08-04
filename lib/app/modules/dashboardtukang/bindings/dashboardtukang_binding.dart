import 'package:get/get.dart';

import '../controllers/dashboardtukang_controller.dart';

class DashboardtukangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardtukangController>(
      () => DashboardtukangController(),
    );
  }
}
