import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/edit_profile_screen_controller.dart';

class EditProfileScreenView extends GetView<EditProfileScreenController> {
  const EditProfileScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EditProfileScreenView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'EditProfileScreenView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
