import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tukangapptwo/app/modules/buttonregister/views/buttonregister_view.dart';
import 'package:tukangapptwo/app/modules/dashboarduser/views/dashboarduser_view.dart';


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

  void _handleLogin() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );

    User? user = userCredential.user;
      if (user != null) {
        print('Signed in as ${user.email}');
      } else {
        print('Failed to sign in');
      }
      _showFlushBar("Login successful", Colors.green, () {});
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboarduserView()),
        );
      });
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
                                    builder: (context) => ButtonregisterView(),
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