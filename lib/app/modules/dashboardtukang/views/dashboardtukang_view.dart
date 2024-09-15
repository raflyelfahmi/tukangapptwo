import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tukangapptwo/app/modules/cekordertukang/views/cekordertukang_view.dart';
import 'package:tukangapptwo/app/modules/kelolaakuntukang/views/kelolaakuntukang_view.dart';
import 'package:tukangapptwo/app/modules/profilscreen_tukang/views/profilscreen_tukang_view.dart';

class DashboardtukangView extends StatefulWidget {
  const DashboardtukangView({super.key});

  @override
  State<DashboardtukangView> createState() => _DashboardtukangViewState();
}

class _DashboardtukangViewState extends State<DashboardtukangView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  bool _isTukang = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  void _checkUserRole() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DatabaseEvent event = await _database.child('users/${user.uid}/role').once();
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        String role = snapshot.value as String;
        setState(() {
          if (role == 'tukang') {
            _isTukang = true;
          }
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_isTukang) {
      return const Scaffold(
        body: Center(child: Text('Akses ditolak')),
      );
    }

    String? email = _auth.currentUser?.email;

    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff9a0000),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (email != null)
              // Text(
              //   'Hai $email !',
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
            Opacity(
              opacity: 0.9,
              child: Image.asset(
                "assets/logo/logo nama white.png",
                height: 20,
                fit: BoxFit.fitHeight,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Tambahkan widget baru di sini
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xff9a0000),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tukang',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.build,
                          size: 50,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          email ?? 'email@gmail.com',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16), // Tambahkan jarak antara widget baru dan GridView
            Expanded(
              flex: 1,
              child: GridView(
                padding: const EdgeInsets.all(16),
                shrinkWrap: false,
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.3,
                ),
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const KelolaakuntukangView()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xff9a0000), width: 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/icon/painter.png",
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Kelola Informasi",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 12,
                              color: Color(0xff9a0000),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CekOrderTukangView()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xff9a0000), width: 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/icon/ceramist.png",
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Cek Order",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 12,
                              color: Color(0xff9a0000),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfilscreenTukangView()),
          );
        },
        backgroundColor: const Color(0xff9a0000),
        child: const Icon(Icons.person),
      ),
    );
  }
}