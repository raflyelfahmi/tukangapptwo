// import 'package:flutter/material.dart';

// class DashboarduserViewView extends StatelessWidget {
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
//         title: Text(
//           "Dashboard",
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             fontStyle: FontStyle.normal,
//             fontSize: 20,
//             color: Color(0xffffffff),
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: EdgeInsets.all(4),
//             child:
//                 Icon(Icons.notifications, color: Color(0xffffffff), size: 20),
//           ),
//           Padding(
//             padding: EdgeInsets.all(4),
//             child: Icon(Icons.person, color: Color(0xffffffff), size: 20),
//           ),
//         ],
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
//                 Container(
//                   alignment: Alignment.center,
//                   margin: EdgeInsets.all(0),
//                   padding: EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Color(0x1fffffff),
//                     shape: BoxShape.rectangle,
//                     borderRadius: BorderRadius.circular(12.0),
//                     border: Border.all(color: Color(0x4d9e9e9e), width: 1),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       ///***If you have exported images you must have to copy those images in assets/images directory.
//                       Image(
//                         image: AssetImage("assets/images/Frame.png"),
//                         height: 30,
//                         width: 30,
//                         fit: BoxFit.cover,
//                       ),
//                       Text(
//                         "Painter",
//                         textAlign: TextAlign.start,
//                         overflow: TextOverflow.clip,
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
//                 Container(
//                   alignment: Alignment.center,
//                   margin: EdgeInsets.all(0),
//                   padding: EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Color(0x1fffffff),
//                     shape: BoxShape.rectangle,
//                     borderRadius: BorderRadius.circular(12.0),
//                     border: Border.all(color: Color(0x4d9e9e9e), width: 1),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       ///***If you have exported images you must have to copy those images in assets/images directory.
//                       Image(
//                         image: AssetImage("assets/images/Frame-%281%29.png"),
//                         height: 30,
//                         width: 30,
//                         fit: BoxFit.cover,
//                       ),
//                       Text(
//                         "Ceramist",
//                         textAlign: TextAlign.start,
//                         overflow: TextOverflow.clip,
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
//                 Container(
//                   alignment: Alignment.center,
//                   margin: EdgeInsets.all(0),
//                   padding: EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Color(0x1fffffff),
//                     shape: BoxShape.rectangle,
//                     borderRadius: BorderRadius.circular(12.0),
//                     border: Border.all(color: Color(0x4d9e9e9e), width: 1),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       ///***If you have exported images you must have to copy those images in assets/images directory.
//                       Image(
//                         image: AssetImage("assets/images/Frame-%282%29.png"),
//                         height: 30,
//                         width: 30,
//                         fit: BoxFit.cover,
//                       ),
//                       Text(
//                         "Rooftile",
//                         textAlign: TextAlign.start,
//                         overflow: TextOverflow.clip,
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
//                 Container(
//                   alignment: Alignment.center,
//                   margin: EdgeInsets.all(0),
//                   padding: EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Color(0x1fffffff),
//                     shape: BoxShape.rectangle,
//                     borderRadius: BorderRadius.circular(12.0),
//                     border: Border.all(color: Color(0x4d9e9e9e), width: 1),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       ///***If you have exported images you must have to copy those images in assets/images directory.
//                       Image(
//                         image: AssetImage("assets/images/Frame-%283%29.png"),
//                         height: 30,
//                         width: 30,
//                         fit: BoxFit.cover,
//                       ),
//                       Text(
//                         "Etc",
//                         textAlign: TextAlign.start,
//                         overflow: TextOverflow.clip,
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
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tukangapptwo/app/modules/home/views/login_screen.dart';

// class DashboarduserView extends StatefulWidget {
//   const DashboarduserView({super.key});

//   @override
//   State<DashboarduserView> createState() => _DashboarduserViewState();
// }

// class _DashboarduserViewState extends State<DashboarduserView> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override
//   Widget build(BuildContext context) {
//     String? _email = _auth.currentUser!.email;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Dasboard"),
//       ),
//       // body: Center(
//       //   child: Padding(
//       //     padding: EdgeInsets.all(20),
//       //     child: Column(
//       //       mainAxisAlignment: MainAxisAlignment.center,
//       //       children: [
//       //         Text("Logged In With: $_email"),
//       //         SizedBox(
//       //           height: 50,
//       //         ),
//       //         ElevatedButton(
//       //           onPressed: () {
//       //             _auth.signOut();
//       //             Navigator.push(
//       //                 context,
//       //                 MaterialPageRoute(
//       //                   builder: (context) => LoginScreen(),
//       //                 ));
//       //           },
//       //           style: ElevatedButton.styleFrom(
//       //             foregroundColor: Colors.white,
//       //             backgroundColor: Color(0xFF9A0000), // Warna teks
//       //           ),
//       //           child: Text("SignOut"),
//       //         ),
//       //       ],
//       //     ),
//       //   ),
//       // ),
//     ); //Scaffold
//   }
// }



import 'package:flutter/material.dart';

class DashboarduserView extends StatefulWidget {
const DashboarduserView({super.key});

  @override
  State<DashboarduserView> createState() => _DashboarduserViewState();
}


class _DashboarduserViewState extends State<DashboarduserView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    String? _email = _auth.currentUser!.email;
    return Scaffold(
      backgroundColor: Color(0xffffffff),
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
        actions: [
          Padding(
            padding: EdgeInsets.all(4),
            child:
                Icon(Icons.notifications, color: Color(0xffffffff), size: 20),
          ),
          Padding(
            padding: EdgeInsets.all(4),
            child: Icon(Icons.person, color: Color(0xffffffff), size: 20),
          ),
        ],
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
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0x1fffffff),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Color(0x4d9e9e9e), width: 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ///***If you have exported images you must have to copy those images in assets/images directory.
                      Image(
                        image: AssetImage("assets/images/Frame.png"),
                        height: 30,
                        width: 30,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        "Painter",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
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
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0x1fffffff),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Color(0x4d9e9e9e), width: 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ///***If you have exported images you must have to copy those images in assets/images directory.
                      Image(
                        image: AssetImage("assets/images/Frame-%281%29.png"),
                        height: 30,
                        width: 30,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        "Ceramist",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
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
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0x1fffffff),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Color(0x4d9e9e9e), width: 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ///***If you have exported images you must have to copy those images in assets/images directory.
                      Image(
                        image: AssetImage("assets/images/Frame-%282%29.png"),
                        height: 30,
                        width: 30,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        "Rooftile",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
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
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0x1fffffff),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Color(0x4d9e9e9e), width: 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ///***If you have exported images you must have to copy those images in assets/images directory.
                      Image(
                        image: AssetImage("assets/images/Frame-%283%29.png"),
                        height: 30,
                        width: 30,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        "Etc",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
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
    );
  }
}
