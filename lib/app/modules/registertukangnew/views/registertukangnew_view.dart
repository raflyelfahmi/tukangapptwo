import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tukangapptwo/app/modules/home/views/login_screen.dart';

class RegistertukangnewView extends StatefulWidget {
  const RegistertukangnewView({Key? key}) : super(key: key);

  @override
  _RegistertukangnewViewState createState() => _RegistertukangnewViewState();
}

class _RegistertukangnewViewState extends State<RegistertukangnewView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _teamCountController = TextEditingController();
  String? _filePath;
  String? _pdfFileName;

  Future<void> _pickPDF() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() {
        _filePath = result.files.first.path; // Menyimpan path file
        _pdfFileName = result.files.first.name;
      });
    }
  }

  Future<void> _registerUser() async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      final User? user = userCredential.user;
      if (user != null) {
        // Upload PDF to Firebase Storage
        String? pdfUrl;
        if (_filePath != null) {
          try {
            final storageRef = FirebaseStorage.instance.ref().child('pdfs/${user.uid}/${_pdfFileName}');
            final uploadTask = storageRef.putFile(File(_filePath!));
            final snapshot = await uploadTask.whenComplete(() => {});
            pdfUrl = await snapshot.ref.getDownloadURL();
          } catch (e) {
            print('Error uploading file: $e');
            Get.snackbar('Error', 'Failed to upload file');
            return;
          }
        }

        // Save user data to Realtime Database
        await FirebaseDatabase.instance.reference().child('users').child(user.uid).set({
          'id': user.uid, // Tambahkan id
          'name': _nameController.text,
          'email': _emailController.text,
          'whatsapp': _whatsappController.text,
          'pdfFileName': _pdfFileName,
          'pdfUrl': pdfUrl,
          'role': 'tukang', // Menandakan bahwa ini adalah akun tukang
          'status': 'pending', // Status pending menunggu persetujuan admin
          'teamCount': int.tryParse(_teamCountController.text),
        }).then((_) {
          print('Data saved successfully');
        }).catchError((error) {
          print('Failed to save data: $error');
          Get.snackbar('Error', 'Failed to save data');
        });

        // Tampilkan pesan popup
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Pendaftaran Berhasil'),
              content: Text('Akun anda sedang kami proses. Proses ini akan memakan waktu kurang lebih 24 jam. Silahkan login lagi setelah 24 jam kedepan.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()), // Ganti dengan LoginScreen Anda
                    );
                  },
                  child: Text('Oke'),
                ),
              ],
            );
          },
        );
      } else {
        Get.snackbar('Error', 'User registration failed');
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Registration failed');
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Color(0xFF6E6E6E)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Color(0xFF6E6E6E)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Color(0xFF6E6E6E), width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Color(0xFF6E6E6E)),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Color(0xFF9A0000), // Warna teks tombol
      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      textStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar sebagai Tukang'),
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
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment:
                        Alignment(0.4, 0.0), // Atur posisi sedikit ke kanan
                    child: Image.asset(
                      'assets/logo/belang new.png',
                      height: 200.0, // Sesuaikan tinggi logo
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration('Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    decoration: _inputDecoration('Email'),
                    keyboardType: TextInputType.emailAddress, // Tambahkan ini
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    decoration: _inputDecoration('Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: _inputDecoration('Konfirmasi Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Konfirmasi Password Anda';
                      }
                      if (value != _passwordController.text) {
                        return 'Password tidak Sesuai';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _whatsappController,
                    decoration: _inputDecoration('Nomor WhatsApp'),
                    keyboardType: TextInputType.number, // Tambahkan ini
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your WhatsApp number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _teamCountController,
                    decoration: _inputDecoration('Jumlah Tim'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the number of team members';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _pickPDF,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF6E6E6E)),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          Expanded( //membungkus Text sehingga teks dapat menggunakan ruang yang tersedia di dalam Row.
                            child: Text(
                              _pdfFileName ?? 'Pick a file',
                              style: TextStyle(color: Color(0xFF6E6E6E)),
                              softWrap: true, // teks akan membungkus ke baris berikutnya jika terlalu panjang
                              overflow: TextOverflow.visible, //memastikan bahwa teks yang melampaui batas akan tetap terlihat dan tidak dipotong.
                            ),
                          ),
                          Icon(Icons.attach_file, color: Color(0xFF6E6E6E)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Upload File adalah untuk mengunggah portofolio atau hasil dari pekerjaan di bidang "tukang" bahwa Anda sudah pernah melakukan pekerjaan tukang.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _registerUser();
                      }
                    },
                    style: _buttonStyle(),
                    child: const Text('Daftar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _whatsappController.dispose();
    _teamCountController.dispose();
    super.dispose();
  }
}