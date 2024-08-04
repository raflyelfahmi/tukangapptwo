import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class EtcController extends GetxController {
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
    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child('users');
    _userSubscription = userRef.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      print('DataSnapshot: ${snapshot.value}');
      if (snapshot.value != null) {
        dynamic values = snapshot.value;
        List<Map<String, dynamic>> userList = [];
        if (values is Map<dynamic, dynamic>) {
          values.forEach((key, value) {
            print('Key: $key, Value: $value');
            if (value is Map<String, dynamic> && value['role'] == 'tukang' && value['rolesKeunggulan'] != null && (value['rolesKeunggulan'] as List).contains('Etc atau Dan Lain-lain')) {
              if (key != currentUserUid) {
                userList.add({
                  'uid': key,
                  'name': value['name'],
                  'email': value['email'],
                  'profileImageUrl': value['profileImageUrl'],
                });
              }
            } else if (value is Map && value['role'] == 'tukang' && value['rolesKeunggulan'] != null && (value['rolesKeunggulan'] as List).contains('Etc atau Dan Lain-lain')) {
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