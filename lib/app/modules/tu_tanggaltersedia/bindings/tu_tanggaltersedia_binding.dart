import 'package:get/get.dart';

import '../controllers/tu_tanggaltersedia_controller.dart';

class TuTanggaltersediaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TuTanggaltersediaController>(
      () => TuTanggaltersediaController(),
    );
  }
}
