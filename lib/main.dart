import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tukangapptwo/app/modules/painter/views/painter_view.dart';
import 'package:tukangapptwo/app/modules/registerbutton/views/registerbutton_view.dart';
import 'package:tukangapptwo/app/modules/registertukangnew/views/registertukangnew_view.dart';
import 'package:tukangapptwo/app/modules/welcomescreenuser/views/welcomescreenuser_view.dart';
import 'package:tukangapptwo/app/modules/dashboarduser/views/dashboarduser_view.dart';
import 'package:tukangapptwo/app/modules/dashboardtukang/views/dashboardtukang_view.dart';
import 'package:tukangapptwo/test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Rent Handy',
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: '/login', page: () => WelcomescreenuserView()),
        GetPage(name: '/registerbutton', page: () => RegisterbuttonView()),
        GetPage(name: '/painter', page: () => PainterView()),
        GetPage(name: '/test', page: () => Test()),
        GetPage(name: '/registertukangnew', page: () => RegistertukangnewView()),
        GetPage(name: '/dashboarduser', page: () => DashboarduserView()),
        GetPage(name: '/dashboardtukang', page: () => DashboardtukangView()),
        // Define other routes here if needed
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      String role = prefs.getString('userRole') ?? 'user';
      if (role == 'tukang') {
        Get.offAll(() => DashboardtukangView());
      } else if (role == 'pemesan') {
        Get.offAll(() => DashboarduserView());
      } else {
        Get.offAll(() => WelcomescreenuserView());
      }
    } else {
      Get.offAll(() => WelcomescreenuserView());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}