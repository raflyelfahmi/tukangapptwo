import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Tambahkan import GetX
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tukangapptwo/app/modules/dashboardtukang/views/dashboardtukang_view.dart';
import 'package:tukangapptwo/app/modules/dashboarduser/views/dashboarduser_view.dart';
import 'package:tukangapptwo/app/modules/registerbutton/views/registerbutton_view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  String _email = "";
  String _password = "";

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
      String uid = prefs.getString('userUid') ?? '';
      bool userExists = await _checkUserExists(uid);
      if (!userExists) {
        await _logout();
        return;
      }
      print('Role from SharedPreferences: $role'); // Tambahkan log untuk role
      if (role == 'tukang') {
        String status = await _getUserStatus(uid);
        String? statusAkun = await _getUserAccountStatus(uid);
        if (statusAkun == 'nonaktif') {
          _showFlushBar("Akun anda telah dinonaktifkan.", Colors.red, () {});
          await _auth.signOut(); // Logout user if account is deactivated
        } else if (status == 'approved') {
          Get.offAll(() => DashboardtukangView()); // Gunakan GetX untuk navigasi
        } else if (status == 'rejected') {
          _showFlushBar("Portofolio yang diunggah belum sesuai kriteria yang dibutuhkan.", Colors.red, () {});
          await _auth.signOut(); // Logout user if rejected
        } else {
          _showFlushBar("Akun Anda belum disetujui oleh admin.", Colors.red, () {});
        }
      } else if (role == 'pemesan') {
        Get.offAll(() => DashboarduserView()); // Gunakan GetX untuk navigasi
      }
    }
  }

  void _handleLogin() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      User? user = userCredential.user;
      if (user != null) {
        print('Signed in as ${user.email}');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userUid', user.uid);

        // Asumsikan role disimpan di Realtime Database
        String role = await _getUserRole(user.uid);
        print('Role from Firebase: $role'); // Tambahkan log untuk role
        await prefs.setString('userRole', role); // Simpan role pengguna

        if (role == 'tukang') {
          String status = await _getUserStatus(user.uid);
          String? statusAkun = await _getUserAccountStatus(user.uid);
          if (statusAkun == 'nonaktif') {
            _showFlushBar("Akun anda telah dinonaktifkan.", Colors.red, () {});
            await _auth.signOut(); // Logout user if account is deactivated
          } else if (status == 'approved') {
            _showFlushBar("Login successful", Colors.green, () {}); // Pindahkan ke sini
            Get.offAll(() => DashboardtukangView()); // Gunakan GetX untuk navigasi
          } else if (status == 'rejected') {
            _showFlushBar("Portofolio yang diunggah belum sesuai kriteria yang dibutuhkan.", Colors.red, () {});
            await _auth.signOut(); // Logout user if rejected
          } else {
            _showFlushBar("Akun Anda belum disetujui oleh admin.", Colors.red, () {});
            await _auth.signOut(); // Logout user if not approved
          }
        } else if (role == 'pemesan') {
          _showFlushBar("Login successful", Colors.green, () {}); // Pindahkan ke sini
          Get.offAll(() => DashboarduserView()); // Gunakan GetX untuk navigasi
        }
      } else {
        print('Failed to sign in');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Login failed";
      if (e.code == 'wrong-password') {
        errorMessage = "Incorrect email or password";
      }
      _showFlushBar(errorMessage, Colors.red, () {});
    } catch (e) {
      _showFlushBar("Login failed: $e", Colors.red, () {});
    }
  }

  Future<String> _getUserRole(String uid) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/$uid/role");
    DatabaseEvent event = await ref.once();
    if (event.snapshot.exists) {
      return event.snapshot.value as String;
    } else {
      throw Exception("User role not found");
    }
  }

  Future<String> _getUserStatus(String uid) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/$uid/status");
    DatabaseEvent event = await ref.once();
    if (event.snapshot.exists) {
      return event.snapshot.value as String;
    } else {
      throw Exception("User status not found");
    }
  }

  Future<String?> _getUserAccountStatus(String uid) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/$uid/statusAkun");
    DatabaseEvent event = await ref.once();
    if (event.snapshot.exists) {
      return event.snapshot.value as String?;
    } else {
      return null; // Return null if statusAkun does not exist
    }
  }

  Future<bool> _checkUserExists(String uid) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/$uid");
    DatabaseEvent event = await ref.once();
    return event.snapshot.exists;
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userRole');
    await prefs.remove('userUid');
    await _auth.signOut();
    Get.offAll(() => LoginScreen()); // Gunakan GetX untuk navigasi
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color(0xFF9A0000), // Mengatur warna AppBar
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
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
                  controller: _passController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
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
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _handleLogin();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFF9A0000), // Warna teks
                  ),
                  child: Text("Login"),
                ),
                SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    text: "Kamu belum punya akun? ",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                    children: [
                      TextSpan(
                        text: "Daftar",
                        style: TextStyle(
                          color: Color(0xFF9A0000),
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterbuttonView(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}