import 'package:get/get.dart';

import '../controllers/pembayaranpesananuser_controller.dart';

class PembayaranpesananuserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PembayaranpesananuserController>(
      () => PembayaranpesananuserController(),
    );
  }
}
