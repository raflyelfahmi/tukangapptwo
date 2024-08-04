import 'package:get/get.dart';

import '../controllers/detailhistorypesanan_user_controller.dart';

class DetailhistorypesananUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailhistorypesananUserController>(
      () => DetailhistorypesananUserController(),
    );
  }
}
