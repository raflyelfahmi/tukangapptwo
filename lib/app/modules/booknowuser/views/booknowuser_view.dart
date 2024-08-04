import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tukangapptwo/app/modules/dashboarduser/views/dashboarduser_view.dart';

class BooknowuserController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String userId;
  late String userRole;
  var tukangName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    userId = _auth.currentUser?.uid ?? '';
    _checkUserRole();
  }

  void _checkUserRole() async {
    DatabaseReference userRef = FirebaseDatabase.instance.ref().child('users/$userId');
    DataSnapshot snapshot = await userRef.child('role').get();
    userRole = snapshot.value as String;
    print('User role: $userRole');
    if (userRole != 'pemesan') {
      Get.offAll(() => const DashboarduserView());
    }
  }

  void fetchTukangName(String tukangUserId) async {
    DatabaseReference tukangRef = FirebaseDatabase.instance.ref().child('users/$tukangUserId');
    DataSnapshot snapshot = await tukangRef.child('name').get();
    tukangName.value = snapshot.value as String;
    print('Tukang name: ${tukangName.value}');
  }
}

class BooknowuserView extends StatelessWidget {
  final String tukangUserId;
  const BooknowuserView({Key? key, required this.tukangUserId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BooknowuserController controller = Get.put(BooknowuserController());
    controller.fetchTukangName(tukangUserId);
    final _formKey = GlobalKey<FormState>();
    final _alamatController = TextEditingController();
    final _tanggalController = TextEditingController();

    void _kirimData() {
      if (_formKey.currentState!.validate()) {
        final DatabaseReference _database = FirebaseDatabase.instance.ref();
        final String orderId = _database.child('orders').push().key!;
        print('Order ID: $orderId');
        print('Tukang User ID: $tukangUserId');

        _database.child('orders/$orderId').set({
          'alamat': _alamatController.text,
          'tanggal': _tanggalController.text,
          'status': 'pending',
          'pemesanId': controller.userId,
          'tukangId': tukangUserId,
        }).then((_) {
          print('Pesanan berhasil disimpan');
          Get.snackbar('Sukses', 'Pesanan berhasil dikirim',
              backgroundColor: Colors.green, colorText: Colors.white);
          Get.defaultDialog(
            title: 'Pesanan Berhasil',
            middleText: 'Pesanan berhasil dibuat. Proses ini akan memakan waktu kurang lebih 24 jam.',
            textConfirm: 'OK',
            confirmTextColor: Colors.white,
            buttonColor: Color(0xFF9A0000),
            onConfirm: () {
              Get.back();
              Get.offAll(() => const DashboarduserView());
            },
          );
        }).catchError((error) {
          print('Error: $error');
          Get.snackbar('Error', 'Gagal mengirim pesanan',
              backgroundColor: Colors.red, colorText: Colors.white);
        });
      }
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesan Tukang'),
        centerTitle: true,
        backgroundColor: Color(0xFF9A0000),
        elevation: 0,
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
                          Icon(Icons.person, size: 50, color: Color(0xFF9A0000)),
                          SizedBox(height: 10),
                          Text(
                            'Tukang yang dipilih:',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          Obx(() => Text(
                            '${controller.tukangName.value}',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF9A0000)),
                          )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  TextFormField(
                    controller: _alamatController,
                    decoration: InputDecoration(
                      labelText: 'Alamat Lengkap',
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
                      prefixIcon: Icon(Icons.location_on, color: Color(0xFF9A0000)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Alamat lengkap harus diisi';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _tanggalController,
                    decoration: InputDecoration(
                      labelText: 'Tanggal Survey',
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
                        return 'Tanggal survey harus diisi';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _kirimData,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        'Kirim Pesanan',
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
        ),
      ),
    );
  }
}