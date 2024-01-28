import 'package:flutter/material.dart';
import 'package:muslim_guide/screens/home_screen.dart';
import 'package:muslim_guide/screens/register_screen.dart';
import 'package:muslim_guide/screens/schedule_screen.dart';

class MuslimGuide extends StatefulWidget {
  const MuslimGuide({super.key});

  @override
  State<MuslimGuide> createState() {
    return _MuslimGuideState();
  }
}

class _MuslimGuideState extends State<MuslimGuide> {
  int activeScreen = 1;

  void switchScreen(int switchingScreen) {
    //maybe change the parameter or method
    setState(() {
      activeScreen = switchingScreen;
    });
  }

  @override
  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
        body: ScheduleScreen(),
        body: ScheduleScreen(),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          // Customize height
          iconSize: 24,
          onTap: (int index) {
            setState(() {
              activeScreen = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart), label: 'Performance'),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month), label: 'Schedule'),
            BottomNavigationBarItem(
                icon: Icon(Icons.book_sharp), label: 'Quran'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
      ),
    );
  }
}
