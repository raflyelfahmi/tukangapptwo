import 'package:flutter/material.dart';
import 'package:tukangapptwo/app/modules/registertukangnew/views/registertukangnew_view.dart';
import 'package:tukangapptwo/app/modules/registeruser/views/registeruser_view.dart';

class RegisterbuttonView extends StatelessWidget {
  const RegisterbuttonView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF9A0000), Color(0xFF6E6E6E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 10.0, // Bayangan di bawah AppBar
        shadowColor: Colors.black.withOpacity(0.5), // Warna bayangan
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 22.0,
          fontWeight: FontWeight.w600,
          fontFamily: 'Roboto', // Gunakan font yang lebih modern
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Warna ikon di AppBar
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff9a0000), Color(0xffd32f2f)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisteruserView()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 40), backgroundColor: Colors.transparent, // Warna latar belakang
                    shadowColor: Colors.transparent, // Menghilangkan bayangan default
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Radius tombol
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18, // Ukuran teks tombol
                      fontWeight: FontWeight.bold, // Tebal teks tombol
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.person_add, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Daftar sebagai Pemesan",
                        style: TextStyle(
                          color: Colors.white, // Warna teks
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16), // Menambahkan jarak antara dua tombol
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff9a0000), Color(0xffd32f2f)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistertukangnewView()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 40), backgroundColor: Colors.transparent, // Warna latar belakang
                    shadowColor: Colors.transparent, // Menghilangkan bayangan default
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Radius tombol
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18, // Ukuran teks tombol
                      fontWeight: FontWeight.bold, // Tebal teks tombol
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.build, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Daftar sebagai Tukang",
                        style: TextStyle(
                          color: Colors.white, // Warna teks
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}