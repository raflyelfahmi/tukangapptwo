import 'package:get/get.dart';

import '../controllers/detailhistorypesanan_tukang_controller.dart';

class DetailhistorypesananTukangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailhistorypesananTukangController>(
      () => DetailhistorypesananTukangController(),
    );
  }
}
