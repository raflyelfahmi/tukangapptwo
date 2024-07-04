import 'package:flutter/material.dart';
import 'package:tukangapptwo/app/component/navbar_view.dart';
import 'package:tukangapptwo/app/modules/dashboarduser/views/dashboarduser_view.dart';
import 'package:tukangapptwo/app/modules/profilscreen/views/profilscreen_view.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  
  @override
  State<NotificationView> createState() => _NotificationView();
}

class _NotificationView extends State<NotificationView> {
  
  int _currentIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                 NotificationView()), // Make sure this is the correct navigation logic
        );
      }

      if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProfilscreenView()), // Make sure this is the correct navigation logic
        );
      }
      if (index == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DashboarduserView()), // Make sure this is the correct navigation logic
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NotificationView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'NotificationView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: _currentIndex, onTap: _onItemTapped,),
    );
  }
}
