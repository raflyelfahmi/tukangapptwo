import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tukangapptwo/app/modules/home/views/login_screen.dart';
import 'package:tukangapptwo/app/modules/registerbutton/views/registerbutton_view.dart';

class RegistertukangView extends StatefulWidget {
  const RegistertukangView({Key? key}) : super(key: key);

  @override
  State<RegistertukangView> createState() => _RegisteruserViewState();
}

class _RegisteruserViewState extends State<RegistertukangView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  String _name = "";
  String _email = "";
  String _password = "";
  File? _selectedPdf;

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

      // Simpan data pengguna ke Realtime Database
      DatabaseReference userRef =
          _database.ref().child("users").child(userCredential.user!.uid);
      await userRef.set({
        "name": _name,
        "email": _email,
      });

      _showFlushBar(
        "User telah terdaftar: ${userCredential.user!.email}",
        Colors.green,
        () {
          // Setelah menampilkan notifikasi, pindah ke halaman login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    LoginScreen()), // Sesuaikan dengan navigasi Anda
          );
        },
      );
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

  Future<void> uploadFile() async {
    // Check and request permission
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      if (await Permission.storage.request().isGranted) {
        // Permission granted, proceed with file picking
        await pickAndUploadFile();
      } else {
        // Permission denied, handle accordingly
        print("Storage permission denied");
      }
    } else {
      // Permission already granted, proceed with file picking
      await pickAndUploadFile();
    }
  }

  Future<void> pickAndUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String filename = result.files.first.name;
      print(file);
      try {
        await FirebaseStorage.instance.ref(filename).putFile(file);
        setState(() {
          _selectedPdf = file;
        });
        print("File uploaded successfully: $filename");
      } catch (e) {
        print("Failed to upload file: $e");
      }
    } else {
      // User canceled the picker
      print("Membatalkan Upload File");
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.white), // Mengatur warna ikon panah belakang
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      RegisterbuttonView()), // Sesuaikan dengan navigasi Anda
            );
          },
        ),
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
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
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
                  onPressed: uploadFile,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  child: Text('Select PDF'),
                ),
                if (_selectedPdf != null) ...[
                  SizedBox(height: 10),
                  Text(
                    'Selected PDF: ${_selectedPdf!.path.split('/').last}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
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







// import 'dart:io';

// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:permission_handler/permission_handler.dart';

// class RegistertukangView extends StatefulWidget {
//   const RegistertukangView({super.key});

//   @override
//   State<RegistertukangView> createState() => _RegistertukangViewState();
// }

// class _RegistertukangViewState extends State<RegistertukangView> {
//   File? file;
//   String? url;
//   var name;
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(height: 20),
//             MaterialButton(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20)),
//               elevation: 4,
//               height: 60,
//               color: Color(0xFF9A0000),
//               onPressed: () {
//                 getFile();
//               },
//               child: Text(
//                 "Upload File",
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// //pick the file
//   getFile() async {
//     // Meminta izin penyimpanan
//     var status = await Permission.storage.status;
//     if (!status.isGranted) {
//       if (await Permission.storage.request().isGranted) {
//         // Izin diberikan, lanjutkan dengan pemilihan file
//         await pickFile();
//       } else {
//         // Izin ditolak, tangani sesuai kebutuhan
//         Fluttertoast.showToast(
//             msg: "Izin penyimpanan ditolak",
//             textColor: Colors.red,
//             backgroundColor: Colors.green);
//       }
//     } else {
//       // Izin sudah diberikan, lanjutkan dengan pemilihan file
//       await pickFile();
//     }
//   }

//   Future<void> pickFile() async {
//     FilePickerResult? result = await FilePicker.platform
//         .pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'doc']);
//     if (result != null) {
//       File C = File(result.files.single.path.toString());
//       setState(() {
//         file = C;
//         name = result.names.toString();
//       });
//       uploadFile();
//     }
//   }

// //for upload the file
//   uploadFile() async {
//     try {
//       //file is stored in firebase storage
//       var myFile =
//           FirebaseStorage.instance.ref().child("Userstukang").child('/$name');
//       UploadTask task = myFile.putFile(file!);
//       TaskSnapshot snapshot = await task;
//       url = await snapshot.ref.getDownloadURL();
//       print(url);
//       if (url != null && file != null) {
//         Fluttertoast.showToast(
//             msg: "File uploaded successfully",
//             textColor: Colors.white,
//             backgroundColor: Colors.green);
//       } else {
//         Fluttertoast.showToast(
//             msg: "Something went wrong",
//             textColor: Colors.red,
//             backgroundColor: Colors.green);
//       }
//     } on Exception catch (e) {
//       Fluttertoast.showToast(
//           msg: e.toString(),
//           textColor: Colors.red,
//           backgroundColor: Colors.green);
//     }
//   }
// }