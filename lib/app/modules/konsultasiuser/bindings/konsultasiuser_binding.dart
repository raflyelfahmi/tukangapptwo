import 'package:get/get.dart';

import '../controllers/konsultasiuser_controller.dart';

class KonsultasiuserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KonsultasiuserController>(
      () => KonsultasiuserController(),
    );
  }
}
