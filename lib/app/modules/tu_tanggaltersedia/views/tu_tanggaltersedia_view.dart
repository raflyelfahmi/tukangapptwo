import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TuTanggaltersediaView extends StatefulWidget {
  const TuTanggaltersediaView({Key? key}) : super(key: key);

  @override
  _TuTanggaltersediaViewState createState() => _TuTanggaltersediaViewState();
}

class _TuTanggaltersediaViewState extends State<TuTanggaltersediaView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tanggalController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  bool _isLoading = true;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
      _loadTanggalTersedia();
    }
  }

  Future<void> _loadTanggalTersedia() async {
    if (_userId != null) {
      final DataSnapshot snapshot = await _database.child('users/$_userId/tanggalTersedia').get();
      if (snapshot.exists) {
        setState(() {
          _tanggalController.text = snapshot.value as String;
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF9A0000),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _tanggalController.text = DateFormat('dd-MM-yyyy').format(picked);
    }
  }

  Future<void> _simpanTanggal() async {
    if (_formKey.currentState!.validate()) {
      if (_userId != null) {
        await _database.child('users/$_userId/tanggalTersedia').set(_tanggalController.text).then((_) {
          Get.snackbar('Sukses', 'Tanggal ketersediaan berhasil disimpan',
              backgroundColor: Colors.green, colorText: Colors.white);
        }).catchError((error) {
          Get.snackbar('Error', 'Gagal menyimpan tanggal ketersediaan',
              backgroundColor: Colors.red, colorText: Colors.white);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tanggal Mulai Ketersediaan Tukang'),
        centerTitle: true,
        backgroundColor: Color(0xFF9A0000),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF9A0000), Colors.white],
            stops: [0.0, 0.3],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _tanggalController,
                            decoration: InputDecoration(
                              labelText: 'Tanggal Ketersediaan',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Color(0xFF6E6E6E)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Color(0xFF6E6E6E)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Color(0xFF6E6E6E)),
                              ),
                              prefixIcon: Icon(Icons.calendar_today, color: Color(0xFF9A0000)),
                            ),
                            readOnly: true,
                            onTap: () => _selectDate(context),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Tanggal ketersediaan harus diisi';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _simpanTanggal,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: Text(
                                'Simpan Tanggal',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF9A0000),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tanggalController.dispose();
    super.dispose();
  }
}