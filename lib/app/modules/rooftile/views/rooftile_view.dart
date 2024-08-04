import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:tukangapptwo/app/modules/userinformasitukang/views/userinformasitukang_view.dart';

class RooftileController extends GetxController {
  var users = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var accessDenied = false.obs; // Tambahkan variabel untuk status akses ditolak
  StreamSubscription<DatabaseEvent>? _userSubscription;

  @override
  void onInit() {
    super.onInit();
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        print('User is authenticated: ${user.uid}');
        String role = await _getUserRole(user.uid);
        if (role == 'pemesan') {
          fetchUsers(user.uid);
        } else {
          accessDenied.value = true; // Setel status akses ditolak
        }
      } else {
        print('User is not authenticated');
        users.clear();
        _userSubscription?.cancel();
      }
    });
  }

  Future<String> _getUserRole(String uid) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/$uid/role");
    DatabaseEvent event = await ref.once();
    if (event.snapshot.exists) {
      return event.snapshot.value as String;
    } else {
      throw Exception("User role not found");
    }
  }

  void fetchUsers(String currentUserUid) {
    isLoading.value = true;
    DatabaseReference userRef = FirebaseDatabase.instance.reference().child('users');
    _userSubscription = userRef.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      print('DataSnapshot: ${snapshot.value}');
      if (snapshot.value != null) {
        dynamic values = snapshot.value;
        List<Map<String, dynamic>> userList = [];
        if (values is Map<dynamic, dynamic>) {
          values.forEach((key, value) {
            print('Key: $key, Value: $value');
            if (value is Map<String, dynamic> && value['role'] == 'tukang' && value['rolesKeunggulan'] != null && (value['rolesKeunggulan'] as List).contains('Rooftile atau Pasang Atap Rumah')) {
              if (key != currentUserUid) {
                userList.add({
                  'uid': key,
                  'name': value['name'],
                  'email': value['email'],
                  'profileImageUrl': value['profileImageUrl'],
                });
              }
            } else if (value is Map && value['role'] == 'tukang' && value['rolesKeunggulan'] != null && (value['rolesKeunggulan'] as List).contains('Rooftile atau Pasang Atap Rumah')) {
              if (key != currentUserUid) {
                userList.add({
                  'uid': key,
                  'name': value['name'],
                  'email': value['email'],
                  'profileImageUrl': value['profileImageUrl'],
                });
              }
            } else {
              print('Value is not a valid user object or does not have the required role keunggulan');
            }
          });
        } else {
          print('Snapshot value is not a Map');
        }
        users.assignAll(userList);
      } else {
        print('No users available');
        users.clear();
      }
      isLoading.value = false;
    });
  }

  @override
  void onClose() {
    _userSubscription?.cancel();
    super.onClose();
  }
}

class RooftileView extends StatelessWidget {
  const RooftileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RooftileController rooftileController = Get.put(RooftileController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RooftileView',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF9A0000),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (rooftileController.accessDenied.value) {
          return Center(
            child: Text(
              'Akses Ditolak',
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
          );
        } else if (rooftileController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (rooftileController.users.isEmpty) {
          return const Center(
            child: Text(
              'No users found',
              style: TextStyle(fontSize: 20),
            ),
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: rooftileController.users.length,
                  itemBuilder: (context, index) {
                    var user = rooftileController.users[index];
                    return InkWell(
                      onTap: () {
                        Get.to(() => UserinformasitukangView(userId: user['uid'])); // Ubah parameter menjadi userId
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 0.7),
                        padding: EdgeInsets.all(10),
                        height: 70, // Atur tinggi setiap item
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              backgroundImage: user['profileImageUrl'] != null
                                  ? NetworkImage(user['profileImageUrl'])
                                  : null,
                              child: user['profileImageUrl'] == null
                                  ? Icon(Icons.person,
                                      size: 50, color: Color(0xff9a0000))
                                  : null,
                            ),
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user['name'] ?? 'Name not available',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  user['email'] ?? 'Email not available',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}