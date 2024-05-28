// import 'package:flutter/material.dart';

// import '../../buttonregister/views/buttonregister_view.dart';

// class RegisteruserView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xffffffff),
//       appBar: AppBar(
//         elevation: 4,
//         centerTitle: false,
//         automaticallyImplyLeading: false,
//         backgroundColor: Color(0xff9a0000),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.zero,
//         ),
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back,
//             color: Color(0xffffffff),
//             size: 20,
//           ),
//           onPressed: () {
//             Navigator.of(context).pushReplacement(
//               MaterialPageRoute(
//                 builder: (context) => ButtonregisterView(),
//               ),
//             );
//           },
//         ),
//       ),
//       body: Align(
//         alignment: Alignment.center,
//         child: Padding(
//           padding: EdgeInsets.all(16),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 ///***If you have exported images you must have to copy those images in assets/images directory.
//                 Image(
//                   image: AssetImage("assets/images/icons8-person-64.png"),
//                   height: 120,
//                   width: 120,
//                   fit: BoxFit.cover,
//                 ),
//                 Text(
//                   "Register User",
//                   textAlign: TextAlign.start,
//                   overflow: TextOverflow.clip,
//                   style: TextStyle(
//                     fontWeight: FontWeight.w700,
//                     fontStyle: FontStyle.normal,
//                     fontSize: 22,
//                     color: Color(0xff000000),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.fromLTRB(0, 32, 0, 0),
//                   child: TextField(
//                     controller: TextEditingController(),
//                     obscureText: false,
//                     textAlign: TextAlign.start,
//                     maxLines: 1,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w400,
//                       fontStyle: FontStyle.normal,
//                       fontSize: 14,
//                       color: Color(0xff000000),
//                     ),
//                     decoration: InputDecoration(
//                       disabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(4.0),
//                         borderSide:
//                             BorderSide(color: Color(0xff000000), width: 1),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(4.0),
//                         borderSide:
//                             BorderSide(color: Color(0xff000000), width: 1),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(4.0),
//                         borderSide:
//                             BorderSide(color: Color(0xff000000), width: 1),
//                       ),
//                       hintText: "username",
//                       hintStyle: TextStyle(
//                         fontWeight: FontWeight.w400,
//                         fontStyle: FontStyle.normal,
//                         fontSize: 14,
//                         color: Color(0xff000000),
//                       ),
//                       filled: true,
//                       fillColor: Color(0xfff2f2f3),
//                       isDense: false,
//                       contentPadding: EdgeInsets.all(8),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
//                   child: TextField(
//                     controller: TextEditingController(),
//                     obscureText: false,
//                     textAlign: TextAlign.start,
//                     maxLines: 1,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w400,
//                       fontStyle: FontStyle.normal,
//                       fontSize: 14,
//                       color: Color(0xff000000),
//                     ),
//                     decoration: InputDecoration(
//                       disabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(4.0),
//                         borderSide:
//                             BorderSide(color: Color(0xff000000), width: 1),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(4.0),
//                         borderSide:
//                             BorderSide(color: Color(0xff000000), width: 1),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(4.0),
//                         borderSide:
//                             BorderSide(color: Color(0xff000000), width: 1),
//                       ),
//                       hintText: "email",
//                       hintStyle: TextStyle(
//                         fontWeight: FontWeight.w400,
//                         fontStyle: FontStyle.normal,
//                         fontSize: 14,
//                         color: Color(0xff000000),
//                       ),
//                       filled: true,
//                       fillColor: Color(0xfff2f2f3),
//                       isDense: false,
//                       contentPadding: EdgeInsets.all(8),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
//                   child: TextField(
//                     controller: TextEditingController(),
//                     obscureText: true,
//                     textAlign: TextAlign.start,
//                     maxLines: 1,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w400,
//                       fontStyle: FontStyle.normal,
//                       fontSize: 14,
//                       color: Color(0xff000000),
//                     ),
//                     decoration: InputDecoration(
//                       disabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(4.0),
//                         borderSide:
//                             BorderSide(color: Color(0xff000000), width: 1),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(4.0),
//                         borderSide:
//                             BorderSide(color: Color(0xff000000), width: 1),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(4.0),
//                         borderSide:
//                             BorderSide(color: Color(0xff000000), width: 1),
//                       ),
//                       hintText: "password",
//                       hintStyle: TextStyle(
//                         fontWeight: FontWeight.w400,
//                         fontStyle: FontStyle.normal,
//                         fontSize: 14,
//                         color: Color(0xff000000),
//                       ),
//                       filled: true,
//                       fillColor: Color(0xfff2f2f3),
//                       isDense: false,
//                       contentPadding: EdgeInsets.all(8),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.fromLTRB(0, 32, 0, 0),
//                   child: MaterialButton(
//                     onPressed: () {},
//                     color: Color(0xff9a0000),
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(22.0),
//                       side: BorderSide(color: Color(0xff808080), width: 1),
//                     ),
//                     padding: EdgeInsets.all(16),
//                     child: Text(
//                       "Register",
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                         fontStyle: FontStyle.normal,
//                       ),
//                     ),
//                     textColor: Color(0xffffffff),
//                     height: 40,
//                     minWidth: 140,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisteruserView extends StatefulWidget {
  const RegisteruserView({super.key});

  @override
  State<RegisteruserView> createState() => _RegisteruserViewState();
}

class _RegisteruserViewState extends State<RegisteruserView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  String _email = "";
  String _password = "";

  void _handleSignUp() async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: _email, password: _password);
      print("User Registered: ${userCredential.user!.email}");
    } catch (e) {
      print("Error During Registration: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sign Up",
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
                      _handleSignUp();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFF9A0000), // Warna teks
                  ),
                  child: Text("Sign Up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}