import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Container(
      width: 390,
      height: 100,
      child: Stack(
        children: [
          Positioned(
            left: -25,
            right: -25,
            top: 30,
            child: Container(
              width: 390,
              height: 80,
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(
                  width: 0.50,
                  color: Colors.black.withOpacity(0.28999999165534973),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, -4),
                    spreadRadius: 0,
                  ),
                ],
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          Positioned(
            left: 159,
            top: 5,
            child: Container(
              width: 88,
              height: 57,
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, -4),
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 164,
            top: 9,
            child: GestureDetector(
              onTap: () {
                widget.onTap(0);
              },
              onTapDown: (_) {
                setState(() {
                  _hoveredIndex = 0;
                });
              },
              child: Container(
                width: 78,
                height: 50,
                decoration: BoxDecoration(
                  color: widget.currentIndex == 0
                      ? Color(0xff9a0000)
                      : _hoveredIndex == 0
                          ? Color(0xff9a0000)
                          : Color(0xFFA4A4A4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          ),
          Positioned(
            left: 275,
            top: 40,
            child: GestureDetector(
              onTap: () {
                widget.onTap(1);
              },
              onTapDown: (_) {
                setState(() {
                  _hoveredIndex = 1;
                });
              },
              child: Container(
                width: 70,
                height: 26,
                decoration: BoxDecoration(
                  color: widget.currentIndex == 1
                      ? Color(0xff9a0000)
                      : _hoveredIndex == 1
                          ? Color(0xff9a0000)
                          : Color(0xFFA4A4A4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          Positioned(
            left: 75,
            top: 40,
            child: GestureDetector(
              onTap: () {
                widget.onTap(3);
              },
              onTapDown: (_) {
                setState(() {
                  _hoveredIndex = 3;
                });
              },
              child: Container(
                width: 35,
                height: 35,
                decoration: const BoxDecoration(),
                child: Icon(
                  Icons.notifications,
                  color: widget.currentIndex == 3
                      ? Color(0xff9a0000)
                      : _hoveredIndex == 3
                          ? Color(0xff9a0000)
                          : Color(0xFFA4A4A4),
                  size: 28,
                ),
              ),
            ),
          ),
          Positioned(
            left: 191,
            top: 70,
            child: Text(
              'HOME',
              style: TextStyle(
                color: textColor,
                fontSize: 10,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Positioned(
            left: 70,
            top: 70,
            child: Text(
              'Notification',
              style: TextStyle(
                color: textColor,
                fontSize: 10,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Positioned(
            left: 299,
            top: 70,
            child: Text(
              'Profil',
              style: TextStyle(
                color: textColor,
                fontSize: 10,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
