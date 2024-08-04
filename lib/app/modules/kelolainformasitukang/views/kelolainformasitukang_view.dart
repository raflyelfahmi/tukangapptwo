import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/kelolainformasitukang_controller.dart';

class KelolainformasitukangView extends GetView<KelolainformasitukangController> {
  const KelolainformasitukangView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Role Keunggulan'),
        centerTitle: true,
      ),
      body: const KelolainformasitukangBody(),
    );
  }
}

class KelolainformasitukangBody extends StatefulWidget {
  const KelolainformasitukangBody({Key? key}) : super(key: key);

  @override
  _KelolainformasitukangBodyState createState() => _KelolainformasitukangBodyState();
}

class _KelolainformasitukangBodyState extends State<KelolainformasitukangBody> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  bool _isTukang = false;
  bool _isLoading = true;
  List<String> _selectedRoles = [];
  final List<String> _roles = ['Painter atau Mengecat', 'Ceramist atau Pasang Keramik', 'Rooftile atau Pasang Atap Rumah', 'Etc atau Dan Lain-lain'];

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
        if (role == 'tukang') {
          setState(() {
            _isTukang = true;
          });
          _loadSelectedRoles();
        }
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _loadSelectedRoles() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DatabaseEvent event = await _database.child('users/${user.uid}/rolesKeunggulan').once();
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        List<String> roles = List<String>.from(snapshot.value as List);
        setState(() {
          _selectedRoles = roles;
        });
      }
    }
  }

  void _submitRoles() {
    User? user = _auth.currentUser;
    if (user != null) {
      _database.child('users/${user.uid}/rolesKeunggulan').set(_selectedRoles).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Roles keunggulan berhasil disimpan')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_isTukang) {
      return const Center(child: Text('Akses ditolak'));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pilih Role Keunggulan:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _roles.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(_roles[index]),
                  value: _selectedRoles.contains(_roles[index]),
                  activeColor: const Color(0xFF9A0000), // Warna background checklist
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedRoles.add(_roles[index]);
                      } else {
                        _selectedRoles.remove(_roles[index]);
                      }
                    });
                  },
                );
              },
            ),
          ),
          const Divider(), // Pembatas
          const Text('Role Keunggulan yang Dipilih:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedRoles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.brightness_1, size: 8), // Bullet icon
                  title: Text(_selectedRoles[index]),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: _submitRoles,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9A0000), // Warna background button
              ),
              child: const Text(
                'Kirim',
                style: TextStyle(color: Colors.white), // Warna font putih
              ),
            ),
          ),
        ],
      ),
    );
  }
}