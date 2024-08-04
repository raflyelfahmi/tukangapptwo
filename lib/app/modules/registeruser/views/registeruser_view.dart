import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tukangapptwo/app/modules/home/views/login_screen.dart';
import 'package:tukangapptwo/app/modules/registerbutton/views/registerbutton_view.dart';

class RegisteruserView extends StatefulWidget {
  const RegisteruserView({Key? key}) : super(key: key);

  @override
  State<RegisteruserView> createState() => _RegisteruserViewState();
}

class _RegisteruserViewState extends State<RegisteruserView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String _name = "";
  String _email = "";
  String _password = "";
  String _confirmPassword = "";

  void _handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      // Set nama pengguna setelah berhasil mendaftar
      await userCredential.user!.updateDisplayName(_name);

      // Simpan data pengguna ke Realtime Database dengan role "pemesan"
      DatabaseReference userRef =
          _database.ref().child("users").child(userCredential.user!.uid);
      await userRef.set({
        "name": _name,
        "email": _email,
        "role": "pemesan", // Tambahkan peran "pemesan"
      });

      _showFlushBar(
          "User telah terdaftar: ${userCredential.user!.email}", Colors.green,
          () {
        // Setelah menampilkan notifikasi, pindah ke halaman login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      });
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Email sudah digunakan. Gunakan email lain.';
          break;
        case 'invalid-email':
          errorMessage = 'Email tidak valid.';
          break;
        case 'weak-password':
          errorMessage =
              'Password terlalu lemah. Gunakan password yang lebih kuat.';
          break;
        default:
          errorMessage = 'Registrasi gagal. Coba lagi.';
          break;
      }
      _showFlushBar(errorMessage, Colors.red, () {});
    } catch (e) {
      _showFlushBar("Registrasi gagal: $e", Colors.red, () {});
    }
  }

  void _showFlushBar(String message, Color color, VoidCallback onDismiss) {
    Flushbar(
      message: message,
      backgroundColor: color,
      duration: Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      margin: EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      onStatusChanged: (status) {
        if (status == FlushbarStatus.DISMISSED) {
          onDismiss();
        }
      },
    )..show(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar sebagai Pemesan'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF9A0000), Color(0xFF6E6E6E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 10.0, // Bayangan di bawah AppBar
        shadowColor: Colors.black.withOpacity(0.5), // Warna bayangan
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 22.0,
          fontWeight: FontWeight.w600,
          fontFamily: 'Roboto', // Gunakan font yang lebih modern
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Warna ikon di AppBar
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RegisterbuttonView()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment(0.4, 0.0), // Atur posisi sedikit ke kanan
                    child: Image.asset(
                      'assets/logo/belang new.png',
                      height: 200.0, // Sesuaikan tinggi logo
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Color(0xFF6E6E6E)), // Ubah warna border
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Color(0xFF6E6E6E), width: 2.0), // Warna border saat diklik
                      ),
                      labelText: "Name",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Your Name";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _name = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Color(0xFF6E6E6E)), // Ubah warna border
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Color(0xFF6E6E6E), width: 2.0), // Warna border saat diklik
                      ),
                      labelText: "Email",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Your Email";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Color(0xFF6E6E6E)), // Ubah warna border
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Color(0xFF6E6E6E), width: 2.0), // Warna border saat diklik
                      ),
                      labelText: "Password",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Your Password";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _password = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Color(0xFF6E6E6E)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Color(0xFF6E6E6E), width: 2.0),
                      ),
                      labelText: "Konfirmasi Password",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Tolong ketik ulang Password Anda";
                      }
                      if (value != _passwordController.text) {
                        return "Passwords tidak sesuai";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _confirmPassword = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _handleSignUp();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF9A0000), // Warna teks
                    ),
                    child: Text("Daftar"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}