import 'package:get/get.dart';

import '../controllers/ceramist_controller.dart';

class CeramistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CeramistController>(
      () => CeramistController(),
    );
  }
}
