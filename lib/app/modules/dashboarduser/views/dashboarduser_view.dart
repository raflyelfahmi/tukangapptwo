import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tukangapptwo/app/modules/ceramist/views/ceramist_view.dart';
import 'package:tukangapptwo/app/modules/component/navbar_view.dart';
import 'package:tukangapptwo/app/modules/etc/views/etc_view.dart';
import 'package:tukangapptwo/app/modules/pesananuser/views/pesananuser_view.dart';
import 'package:tukangapptwo/app/modules/painter/views/painter_view.dart';
import 'package:tukangapptwo/app/modules/profilscreen/views/profilscreen_view.dart';
import 'package:tukangapptwo/app/modules/rooftile/views/rooftile_view.dart';

class DashboarduserView extends StatefulWidget {
  const DashboarduserView({super.key});

  @override
  State<DashboarduserView> createState() => _DashboarduserViewState();
}

class _DashboarduserViewState extends State<DashboarduserView> {
  int _currentIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  bool _isPemesan = false;
  bool _isLoading = true;
  String _userRole = ''; // Added variable to store userRole

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
          _userRole = role; // Store userRole
          if (role == 'pemesan') {
            _isPemesan = true;
          }
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilscreenView()),
        );
      }
      if (index == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboarduserView()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_isPemesan) {
      return Scaffold(
        body: Center(child: Text('Akses ditolak')),
      );
    }

    String? _email = _auth.currentUser?.email;
    final Brightness currentBrightness = Theme.of(context).brightness;
    final Color buttonBackgroundColor =
        currentBrightness == Brightness.dark ? Colors.black : Colors.white;

    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff9a0000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_email != null)
              // Text(
              //   'Hai $_email !',
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
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xff9a0000),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pemesan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                        SizedBox(height: 8),
                        Text(
                          _email ?? 'email@gmail.com',
                          style: TextStyle(
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
            SizedBox(height: 16),
            Expanded(
              flex: 1,
              child: GridView(
                padding: EdgeInsets.all(16),
                shrinkWrap: false,
                scrollDirection: Axis.vertical,
                physics: ScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.3,
                ),
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PainterView()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(8),
                      backgroundColor: buttonBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(color: Color(0xff9a0000), width: 1),
                      ),
                      elevation: 4,
                      shadowColor: Colors.grey,
                      foregroundColor: Colors.grey,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/icon/painter.png",
                            height: 30, width: 30, fit: BoxFit.cover),
                        Text(
                          "Painter",
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
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CeramistView()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(8),
                      backgroundColor: buttonBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(color: Color(0xff9a0000), width: 1),
                      ),
                      elevation: 4,
                      shadowColor: Colors.grey,
                      foregroundColor: Colors.grey,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/icon/ceramist.png",
                            height: 30, width: 30, fit: BoxFit.cover),
                        Text(
                          "Ceramist",
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
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RooftileView()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(8),
                      backgroundColor: buttonBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(color: Color(0xff9a0000), width: 1),
                      ),
                      elevation: 4,
                      shadowColor: Colors.grey,
                      foregroundColor: Colors.grey,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/icon/rooftile.png",
                            height: 30, width: 30, fit: BoxFit.cover),
                        Text(
                          "Rooftile",
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
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EtcView()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(8),
                      backgroundColor: buttonBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(color: Color(0xff9a0000), width: 1),
                      ),
                      elevation: 4,
                      shadowColor: Colors.grey,
                      foregroundColor: Colors.grey,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/icon/etc.png",
                            height: 30, width: 30, fit: BoxFit.cover),
                        Text(
                          "Etc",
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
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        userRole: _userRole,
      ),
    );
  }
}