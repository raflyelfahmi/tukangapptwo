import 'package:get/get.dart';

import '../controllers/detailpesananuser_controller.dart';

class DetailpesananuserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailpesananuserController>(
      () => DetailpesananuserController(),
    );
  }
}
