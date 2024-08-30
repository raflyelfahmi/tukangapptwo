import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tukangapptwo/app/modules/component/navbar_view.dart';
import 'package:tukangapptwo/app/modules/dashboarduser/views/dashboarduser_view.dart';
import 'package:tukangapptwo/app/modules/historytukang/views/historytukang_view.dart';
import 'package:tukangapptwo/app/modules/pesananuser/views/pesananuser_view.dart';

class ProfilscreenTukangView extends StatefulWidget {
  const ProfilscreenTukangView({Key? key}) : super(key: key);

  @override
  _ProfilscreenTukangViewState createState() => _ProfilscreenTukangViewState();
}

class _ProfilscreenTukangViewState extends State<ProfilscreenTukangView> {
  int _currentIndex = 1;

  File? _image;
  String? _imageUrl;
  String? _name;
  String? _email;
  bool _isTukang = false;
  bool _isLoading = true;
  bool _accessDenied = false;
  String _userRole = '';

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  void _checkUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseEvent event = await FirebaseDatabase.instance
          .reference()
          .child('users/${user.uid}/role')
          .once();
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        String role = snapshot.value as String;
        setState(() {
          _userRole = role;
          if (role == 'tukang') {
            _isTukang = true;
            _loadUserProfile();
          } else {
            _accessDenied = true;
          }
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadUserProfile() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DatabaseReference userRef = FirebaseDatabase.instance
            .reference()
            .child('users')
            .child(user.uid);
        DataSnapshot snapshot = await userRef.get();

        if (snapshot.exists) {
          setState(() {
            _name = snapshot.child('name').value as String?;
            _email = snapshot.child('email').value as String?;
            _imageUrl = snapshot.child('profileImageUrl').value as String?;
          });
        } else {
          print('No data available for user: ${user.uid}');
        }
      } else {
        print('Current user is null');
      }
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('profile_images/${user.uid}');
      UploadTask uploadTask = ref.putFile(_image!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      DatabaseReference userRef =
          FirebaseDatabase.instance.reference().child('users').child(user.uid);
      await userRef.update({'profileImageUrl': downloadUrl});

      if (mounted) {
        setState(() {
          _imageUrl = downloadUrl;
        });
      }
    } catch (e) {
      print('Failed to upload image: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PesananUser()),
        );
      }
      if (index == 1) {
        // No need to navigate to ProfilscreenTukangView again from itself
      }
      if (index == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboarduserView()),
        );
      }
    });
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _viewHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HistorytukangView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_accessDenied) {
      return Scaffold(
        body: Center(child: Text('Akses ditolak')),
      );
    }

    User? user = FirebaseAuth.instance.currentUser;
    String? userName = user?.displayName ?? _name ?? 'Name not available';
    String? userEmail = user?.email ?? _email ?? 'Email not available';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Tukang'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
            top: -27,
            left: (MediaQuery.of(context).size.width - 400) / 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(19),
              child: Container(
                width: 400,
                height: 210,
                color: Color(0xff9a0000),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 60),
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            backgroundImage: _imageUrl != null
                                ? NetworkImage(_imageUrl!)
                                : null,
                            child: _imageUrl == null
                                ? Icon(Icons.person,
                                    size: 50, color: Color(0xff9a0000))
                                : null,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          userName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          userEmail,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _viewHistory,
                      icon: Icon(
                        Icons.history,
                        color: Color(0xff9a0000),
                      ),
                      label: Text(
                        'Riwayat',
                        style: TextStyle(
                          color: Color(0xff9a0000),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        textStyle: TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _logout,
                      icon: Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Keluar',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Color(0xff9a0000),
                        textStyle: TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        userRole: _userRole,
      ),
    );
  }
}