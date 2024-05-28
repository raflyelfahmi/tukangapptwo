import 'package:get/get.dart';

import '../controllers/dashboarduser_controller.dart';

class DashboarduserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboarduserController>(
      () => DashboarduserController(),
    );
  }
}
