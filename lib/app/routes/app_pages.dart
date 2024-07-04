import 'package:get/get.dart';

import '../modules/buttonregister/bindings/buttonregister_binding.dart';
import '../modules/buttonregister/views/buttonregister_view.dart';
import '../modules/ceramist/bindings/ceramist_binding.dart';
import '../modules/ceramist/views/ceramist_view.dart';
import '../modules/dashboarduser/bindings/dashboarduser_binding.dart';
import '../modules/dashboarduser/views/dashboarduser_view.dart';
import '../modules/etc/bindings/etc_binding.dart';
import '../modules/etc/views/etc_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/login_screen.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/painter/bindings/painter_binding.dart';
import '../modules/painter/views/painter_view.dart';
import '../modules/profilscreen/bindings/profilscreen_binding.dart';
import '../modules/profilscreen/views/profilscreen_view.dart';
import '../modules/registertukang/bindings/registertukang_binding.dart';
import '../modules/registertukang/views/registertukang_view.dart';
import '../modules/registeruser/bindings/registeruser_binding.dart';
import '../modules/registeruser/views/registeruser_view.dart';
import '../modules/rooftile/bindings/rooftile_binding.dart';
import '../modules/rooftile/views/rooftile_view.dart';
import '../modules/splashscreen/bindings/splashscreen_binding.dart';
import '../modules/splashscreen/views/splashscreen_view.dart';
import '../modules/welcomescreenuser/bindings/welcomescreenuser_binding.dart';
import '../modules/welcomescreenuser/views/welcomescreenuser_view.dart';

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
      page: () => DashboarduserView(),
      binding: DashboarduserBinding(),
    ),
    GetPage(
      name: _Paths.WELCOMESCREENUSER,
      page: () => WelcomescreenuserView(),
      binding: WelcomescreenuserBinding(),
    ),
    GetPage(
      name: _Paths.SPLASHSCREEN,
      page: () => SplashscreenView(),
      binding: SplashscreenBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.PROFILSCREEN,
      page: () => ProfilscreenView(),
      binding: ProfilscreenBinding(),
    ),
    GetPage(
      name: _Paths.PAINTER,
      page: () => const PainterView(),
      binding: PainterBinding(),
    ),
    GetPage(
      name: _Paths.CERAMIST,
      page: () => const CeramistView(),
      binding: CeramistBinding(),
    ),
    GetPage(
      name: _Paths.ROOFTILE,
      page: () => const RooftileView(),
      binding: RooftileBinding(),
    ),
    GetPage(
      name: _Paths.ETC,
      page: () => const EtcView(),
      binding: EtcBinding(),
    ),
  ];
}
