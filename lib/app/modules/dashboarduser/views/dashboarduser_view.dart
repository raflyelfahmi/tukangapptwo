// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:tukangapptwo/app/component/navbar_view.dart';
// import 'package:tukangapptwo/app/modules/ceramist/views/ceramist_view.dart';
// import 'package:tukangapptwo/app/modules/etc/views/etc_view.dart';
// import 'package:tukangapptwo/app/modules/notification/views/notification_view.dart';
// import 'package:tukangapptwo/app/modules/painter/views/painter_view.dart';
// import 'package:tukangapptwo/app/modules/profilscreen/views/profilscreen_view.dart';
// import 'package:tukangapptwo/app/modules/rooftile/views/rooftile_view.dart';

// class DashboarduserView extends StatefulWidget {
//   const DashboarduserView({super.key});

//   @override
//   State<DashboarduserView> createState() => _DashboarduserViewState();
// }

// class _DashboarduserViewState extends State<DashboarduserView> {
//   int _currentIndex = 0;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   void _onItemTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//       if (index == 3) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => NotificationView()),
//         );
//       }

//       if (index == 1) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => ProfilscreenView()),
//         );
//       }
//       if (index == 0) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => DashboarduserView()),
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     String? _email = _auth.currentUser!.email;

//     // Get the current theme brightness
//     final Brightness currentBrightness = Theme.of(context).brightness;

//     // Determine the button background color based on the theme
//     final Color buttonBackgroundColor =
//         currentBrightness == Brightness.dark ? Colors.black : Colors.white;

//     return Scaffold(
//       appBar: AppBar(
//         elevation: 4,
//         centerTitle: false,
//         automaticallyImplyLeading: false,
//         backgroundColor: Color(0xff9a0000),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.zero,
//         ),
//         title: Text(
//           "Dashboard",
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             fontStyle: FontStyle.normal,
//             fontSize: 20,
//             color: Color(0xffffffff),
//           ),
//         ),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisSize: MainAxisSize.max,
//         children: [
//           Expanded(
//             flex: 1,
//             child: GridView(
//               padding: EdgeInsets.all(16),
//               shrinkWrap: false,
//               scrollDirection: Axis.vertical,
//               physics: ScrollPhysics(),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//                 childAspectRatio: 1.3,
//               ),
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => PainterView()),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.all(8),
//                     backgroundColor: buttonBackgroundColor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                       side: BorderSide(color: Color(0x4d9e9e9e), width: 1),
//                     ),
//                     elevation: 2, // Set elevation to show shadow
//                     foregroundColor:
//                         Colors.grey, // Set text color for disabled state
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset("assets/icon/painter.png",
//                           height: 30, width: 30, fit: BoxFit.cover),
//                       Text(
//                         "Painter",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w400,
//                           fontStyle: FontStyle.normal,
//                           fontSize: 12,
//                           color: Color(0xff9a0000),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => CeramistView()),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.all(8),
//                     backgroundColor: buttonBackgroundColor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                       side: BorderSide(color: Color(0x4d9e9e9e), width: 1),
//                     ),
//                     elevation: 2, // Set elevation to show shadow
//                     foregroundColor:
//                         Colors.grey, // Set text color for disabled state
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset("assets/icon/ceramist.png",
//                           height: 30, width: 30, fit: BoxFit.cover),
//                       Text(
//                         "Ceramist",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w400,
//                           fontStyle: FontStyle.normal,
//                           fontSize: 12,
//                           color: Color(0xff9a0000),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => RooftileView()),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.all(8),
//                     backgroundColor: buttonBackgroundColor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                       side: BorderSide(color: Color(0x4d9e9e9e), width: 1),
//                     ),
//                     elevation: 2, // Set elevation to show shadow
//                     foregroundColor:
//                         Colors.grey, // Set text color for disabled state
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset("assets/icon/rooftile.png",
//                           height: 30, width: 30, fit: BoxFit.cover),
//                       Text(
//                         "Rooftile",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w400,
//                           fontStyle: FontStyle.normal,
//                           fontSize: 12,
//                           color: Color(0xff9a0000),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => EtcView()),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.all(8),
//                     backgroundColor: buttonBackgroundColor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                       side: BorderSide(color: Color(0x4d9e9e9e), width: 1),
//                     ),
//                     elevation: 2, // Set elevation to show shadow
//                     foregroundColor:
//                         Colors.grey, // Set text color for disabled state
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset("assets/icon/etc.png",
//                           height: 30, width: 30, fit: BoxFit.cover),
//                       Text(
//                         "Etc",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w400,
//                           fontStyle: FontStyle.normal,
//                           fontSize: 12,
//                           color: Color(0xff9a0000),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavBar(
//         currentIndex: _currentIndex,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }



import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tukangapptwo/app/component/navbar_view.dart';
import 'package:tukangapptwo/app/modules/ceramist/views/ceramist_view.dart';
import 'package:tukangapptwo/app/modules/etc/views/etc_view.dart';
import 'package:tukangapptwo/app/modules/notification/views/notification_view.dart';
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

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationView()),
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
    String? _email = _auth.currentUser!.email;

    // Get the current theme brightness
    final Brightness currentBrightness = Theme.of(context).brightness;

    // Determine the button background color based on the theme
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
        title: Text(
          "Dashboard",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
            fontSize: 20,
            color: Color(0xffffffff),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
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
                    elevation: 2, // Set elevation to show shadow
                    foregroundColor:
                        Colors.grey, // Set text color for disabled state
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
                    elevation: 2, // Set elevation to show shadow
                    foregroundColor:
                        Colors.grey, // Set text color for disabled state
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
                    elevation: 2, // Set elevation to show shadow
                    foregroundColor:
                        Colors.grey, // Set text color for disabled state
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
                    elevation: 2, // Set elevation to show shadow
                    foregroundColor:
                        Colors.grey, // Set text color for disabled state
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
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
