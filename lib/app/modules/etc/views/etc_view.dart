import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/etc_controller.dart';
import 'package:tukangapptwo/app/modules/userinformasitukang/views/userinformasitukang_view.dart';

class EtcView extends GetView<EtcController> {
  const EtcView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EtcController etcController = Get.put(EtcController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EtcView',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF9A0000),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (etcController.accessDenied.value) {
          return Center(
            child: Text(
              'Akses Ditolak',
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
          );
        } else if (etcController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (etcController.users.isEmpty) {
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
                  itemCount: etcController.users.length,
                  itemBuilder: (context, index) {
                    var user = etcController.users[index];
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