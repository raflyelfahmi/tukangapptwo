import 'package:get/get.dart';

import '../modules/buttonregister/bindings/buttonregister_binding.dart';
import '../modules/buttonregister/views/buttonregister_view.dart';
import '../modules/dashboarduser/bindings/dashboarduser_binding.dart';
import '../modules/dashboarduser/views/dashboarduser_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/login_screen.dart';
import '../modules/registertukang/bindings/registertukang_binding.dart';
import '../modules/registertukang/views/registertukang_view.dart';
import '../modules/registeruser/bindings/registeruser_binding.dart';
import '../modules/registeruser/views/registeruser_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => LoginScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.BUTTONREGISTER,
      page: () => ButtonregisterView(),
      binding: ButtonregisterBinding(),
    ),
    GetPage(
      name: _Paths.REGISTERTUKANG,
      page: () => RegistertukangView(),
      binding: RegistertukangBinding(),
    ),
    GetPage(
      name: _Paths.REGISTERUSER,
      page: () => RegisteruserView(),
      binding: RegisteruserBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARDUSER,
      page: () =>  DashboarduserView(),
      binding: DashboarduserBinding(),
    ),
  ];
}
