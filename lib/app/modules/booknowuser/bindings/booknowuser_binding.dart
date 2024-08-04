import 'package:get/get.dart';

import '../controllers/booknowuser_controller.dart';

class BooknowuserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BooknowuserController>(
      () => BooknowuserController(),
    );
  }
}
