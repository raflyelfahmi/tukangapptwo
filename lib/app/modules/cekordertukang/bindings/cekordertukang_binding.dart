import 'package:get/get.dart';

import '../controllers/cekordertukang_controller.dart';

class CekordertukangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CekordertukangController>(
      () => CekordertukangController(),
    );
  }
}
