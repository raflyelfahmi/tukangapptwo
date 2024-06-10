import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tukangapptwo/app/modules/splashscreen/views/splashscreen_view.dart';

void main() async {
  // Inisialisasi Firebase sebelum menjalankan aplikasi
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Jalankan aplikasi
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rent Handy',
      // Menggunakan tema gelap atau terang sesuai dengan tema sistem
      themeMode: ThemeMode.system,
      theme: ThemeData.light(), // Tema terang
      darkTheme: ThemeData.dark(), // Tema gelap
      home:  SplashscreenView(),
    );
  }
}