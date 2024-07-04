import 'package:flutter/material.dart';
import 'package:tukangapptwo/app/component/navbar_view.dart';
import 'package:tukangapptwo/app/modules/dashboarduser/views/dashboarduser_view.dart';
import 'package:tukangapptwo/app/modules/notification/views/notification_view.dart';

class ProfilscreenView extends StatefulWidget {
  const ProfilscreenView({super.key});

  @override
  State<ProfilscreenView> createState() => _ProfilscreenView();
}

class _ProfilscreenView extends State<ProfilscreenView> {
  int _currentIndex = 1;

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
        title: const Text('ProfilscreenView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ProfilscreenView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
