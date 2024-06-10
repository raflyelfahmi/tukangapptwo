import 'package:flutter/material.dart';
import 'package:tukangapptwo/app/modules/welcomescreenuser/views/welcomescreenuser_view.dart';

class SplashscreenView extends StatefulWidget {
  const SplashscreenView({Key? key}) : super(key: key);

  @override
  _SplashscreenViewState createState() => _SplashscreenViewState();
}

class _SplashscreenViewState extends State<SplashscreenView> {
  @override
  void initState() {
    super.initState();
    // Langsung pindah ke tampilan utama setelah 7 detik
    _navigateToWelcome_Screen(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF9A0000),
      body: Center(
        // Tampilkan logo atau gambar splash screen Anda
        child: Image.asset(
          'assets/logo/logo.png', // Ganti dengan path gambar logo Anda
          width: 200.0, // Ganti dengan lebar yang diinginkan
          height: 200.0, // Ganti dengan tinggi yang diinginkan
        ),
      ),
    );
  }

  // Metode untuk pindah ke halaman utama
  void _navigateToWelcome_Screen(BuildContext context) {
    Future.delayed(Duration(seconds: 7), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomescreenuserView()),
      );
    });
  }
}

void main() {
  runApp(MaterialApp(
    home: SplashscreenView(),
  ));
}