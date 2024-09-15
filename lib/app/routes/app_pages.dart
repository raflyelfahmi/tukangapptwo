import 'package:get/get.dart';

import '../modules/EditProfileScreen/bindings/edit_profile_screen_binding.dart';
import '../modules/EditProfileScreen/views/edit_profile_screen_view.dart';
import '../modules/HistoryUser/bindings/history_user_binding.dart';
import '../modules/HistoryUser/views/history_user_view.dart';
import '../modules/booknowuser/bindings/booknowuser_binding.dart';
import '../modules/booknowuser/views/booknowuser_view.dart';
import '../modules/cekordertukang/bindings/cekordertukang_binding.dart';
import '../modules/cekordertukang/views/cekordertukang_view.dart';
import '../modules/ceramist/bindings/ceramist_binding.dart';
import '../modules/ceramist/views/ceramist_view.dart';
import '../modules/dashboardtukang/bindings/dashboardtukang_binding.dart';
import '../modules/dashboardtukang/views/dashboardtukang_view.dart';
import '../modules/dashboarduser/bindings/dashboarduser_binding.dart';
import '../modules/dashboarduser/views/dashboarduser_view.dart';
import '../modules/detailcekorder/bindings/detailcekorder_binding.dart';
import '../modules/detailcekorder/views/detailcekorder_view.dart';
import '../modules/detailhistorypesanan_tukang/bindings/detailhistorypesanan_tukang_binding.dart';
import '../modules/detailhistorypesanan_tukang/views/detailhistorypesanan_tukang_view.dart';
import '../modules/detailhistorypesanan_user/bindings/detailhistorypesanan_user_binding.dart';
import '../modules/detailhistorypesanan_user/views/detailhistorypesanan_user_view.dart';
import '../modules/detailpesananuser/bindings/detailpesananuser_binding.dart';
import '../modules/etc/bindings/etc_binding.dart';
import '../modules/etc/views/etc_view.dart';
import '../modules/historytukang/bindings/historytukang_binding.dart';
import '../modules/historytukang/views/historytukang_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/login_screen.dart';
import '../modules/kelolaakuntukang/bindings/kelolaakuntukang_binding.dart';
import '../modules/kelolaakuntukang/views/kelolaakuntukang_view.dart';
import '../modules/kelolainformasitukang/bindings/kelolainformasitukang_binding.dart';
import '../modules/kelolainformasitukang/views/kelolainformasitukang_view.dart';
import '../modules/konsultasiuser/bindings/konsultasiuser_binding.dart';
import '../modules/konsultasiuser/views/konsultasiuser_view.dart';
import '../modules/painter/bindings/painter_binding.dart';
import '../modules/painter/views/painter_view.dart';
import '../modules/pembayaranpesananuser/bindings/pembayaranpesananuser_binding.dart';
import '../modules/pembayaranpesananuser/views/pembayaranpesananuser_view.dart';
import '../modules/pesananuser/bindings/notification_binding.dart';
import '../modules/pesananuser/views/pesananuser_view.dart';
import '../modules/profilscreen/bindings/profilscreen_binding.dart';
import '../modules/profilscreen/views/profilscreen_view.dart';
import '../modules/profilscreen_tukang/bindings/profilscreen_tukang_binding.dart';
import '../modules/profilscreen_tukang/views/profilscreen_tukang_view.dart';
import '../modules/ratingulasan/bindings/ratingulasan_binding.dart';
import '../modules/ratingulasan/views/ratingulasan_view.dart';
import '../modules/registerbutton/bindings/registerbutton_binding.dart';
import '../modules/registerbutton/views/registerbutton_view.dart';
import '../modules/registertukang/bindings/registertukang_binding.dart';
import '../modules/registertukang/views/registertukang_view.dart';
import '../modules/registertukangnew/bindings/registertukangnew_binding.dart';
import '../modules/registertukangnew/views/registertukangnew_view.dart';
import '../modules/registeruser/bindings/registeruser_binding.dart';
import '../modules/registeruser/views/registeruser_view.dart';
import '../modules/rooftile/bindings/rooftile_binding.dart';
import '../modules/rooftile/views/rooftile_view.dart';
import '../modules/splashscreen/bindings/splashscreen_binding.dart';
import '../modules/splashscreen/views/splashscreen_view.dart';
import '../modules/tu_edittim/bindings/tu_edittim_binding.dart';
import '../modules/tu_edittim/views/tu_edittim_view.dart';
import '../modules/tu_tanggaltersedia/bindings/tu_tanggaltersedia_binding.dart';
import '../modules/tu_tanggaltersedia/views/tu_tanggaltersedia_view.dart';
import '../modules/welcomescreenuser/bindings/welcomescreenuser_binding.dart';
import '../modules/welcomescreenuser/views/welcomescreenuser_view.dart';

import '../modules/detailpesananuser/views/detailpesananuser_view.dart'
    as detailView; // Using alias

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initialRoute = Routes.home;

  static final routes = [
    GetPage(
      name: _Paths.home,
      page: () => const LoginScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.registerTukang,
      page: () => const RegistertukangView(),
      binding: RegistertukangBinding(),
    ),
    GetPage(
      name: _Paths.registerUser,
      page: () => const RegisteruserView(),
      binding: RegisteruserBinding(),
    ),
    GetPage(
      name: _Paths.dashboardUser,
      page: () => const DashboarduserView(),
      binding: DashboarduserBinding(),
    ),
    GetPage(
      name: _Paths.welcomeScreenUser,
      page: () => WelcomescreenuserView(),
      binding: WelcomescreenuserBinding(),
    ),
    GetPage(
      name: _Paths.splashScreen,
      page: () => const SplashscreenView(),
      binding: SplashscreenBinding(),
    ),
    GetPage(
      name: _Paths.notification,
      page: () => const PesananUser(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.profilScreen,
      page: () => const ProfilscreenView(),
      binding: ProfilscreenBinding(),
    ),
    GetPage(
      name: _Paths.painter,
      page: () => PainterView(),
      binding: PainterBinding(),
    ),
    GetPage(
      name: _Paths.ceramist,
      page: () => CeramistView(),
      binding: CeramistBinding(),
    ),
    GetPage(
      name: _Paths.roofTile,
      page: () => const RooftileView(),
      binding: RooftileBinding(),
    ),
    GetPage(
      name: _Paths.etc,
      page: () => const EtcView(),
      binding: EtcBinding(),
    ),
    GetPage(
      name: _Paths.editProfileScreen,
      page: () => const EditProfileScreenView(),
      binding: EditProfileScreenBinding(),
    ),
    GetPage(
      name: _Paths.historyUser,
      page: () => const HistoryUserView(),
      binding: HistoryUserBinding(),
    ),
    GetPage(
      name: _Paths.registerButton,
      page: () => const RegisterbuttonView(),
      binding: RegisterbuttonBinding(),
    ),
    // GetPage(
    //   name: _Paths.userInformasiTukang,
    //   page: () =>  UserinformasitukangView(),
    //   binding: UserinformasitukangBinding(),
    // ),
    GetPage(
      name: _Paths.registerTukangNew,
      page: () => const RegistertukangnewView(),
      binding: RegistertukangnewBinding(),
    ),
    GetPage(
      name: _Paths.dashboardTukang,
      page: () => const DashboardtukangView(),
      binding: DashboardtukangBinding(),
    ),
    GetPage(
      name: _Paths.profilScreenTukang,
      page: () => const ProfilscreenTukangView(),
      binding: ProfilscreenTukangBinding(),
    ),
    GetPage(
      name: _Paths.cekOrderTukang,
      page: () => const CekOrderTukangView(),
      binding: CekordertukangBinding(),
    ),
    GetPage(
      name: _Paths.kelolaInformasiTukang,
      page: () => const KelolainformasitukangView(),
      binding: KelolainformasitukangBinding(),
    ),
    GetPage(
      name: _Paths.konsultasiUser,
      page: () => const KonsultasiuserView(),
      binding: KonsultasiuserBinding(),
    ),
    GetPage(
      name: _Paths.bookNowUser,
      page: () => BooknowuserView(tukangUserId: 'tukangUserId'),
      binding: BooknowuserBinding(),
    ),
    GetPage(
      name: _Paths.PEMBAYARANPESANANUSER,
      page: () => PembayaranpesananuserView(orderId: 'orderId'),
      binding: PembayaranpesananuserBinding(),
    ),
    GetPage(
      name: _Paths.DETAILHISTORYPESANAN_USER,
      page: () => const DetailhistorypesananUserView(
        orderId: '',
      ),
      binding: DetailhistorypesananUserBinding(),
    ),
    GetPage(
      name: _Paths.RATINGULASAN,
      page: () => RatingulasanView(orderId: 'orderId'),
      binding: RatingulasanBinding(),
    ),
    GetPage(
      name: _Paths.HISTORYTUKANG,
      page: () => const HistorytukangView(),
      binding: HistorytukangBinding(),
    ),
    GetPage(
      name: _Paths.DETAILHISTORYPESANAN_TUKANG,
      page: () => DetailhistorypesananTukangView(
          orderId: Get.parameters['orderId'] ?? ''),
      binding: DetailhistorypesananTukangBinding(),
    ),
    GetPage(
      name: _Paths.DETAILPESANANUSER,
      page: () => const detailView.DetailpesananuserView(
        orderId: '', // Anda bisa mengubah ini sesuai kebutuhan
        pemesanName: '', // Anda bisa mengubah ini sesuai kebutuhan
        tukangName: '', // Anda bisa mengubah ini sesuai kebutuhan
      ),
      binding: DetailpesananuserBinding(),
    ),
    GetPage(
      name: _Paths.DETAILCEKORDER,
      page: () => const DetailcekorderView(
          orderId: '', pemesanName: '', tukangName: ''),
      binding: DetailcekorderBinding(),
    ),
    GetPage(
      name: _Paths.KELOLAAKUNTUKANG,
      page: () => const KelolaakuntukangView(),
      binding: KelolaakuntukangBinding(),
    ),
    GetPage(
      name: _Paths.TU_TANGGALTERSEDIA,
      page: () => const TuTanggaltersediaView(),
      binding: TuTanggaltersediaBinding(),
    ),
    GetPage(
      name: _Paths.TU_EDITTIM,
      page: () => const TuEdittimView(),
      binding: TuEdittimBinding(),
    ),
  ];
}
