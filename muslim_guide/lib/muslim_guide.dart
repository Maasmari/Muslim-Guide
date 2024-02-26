import 'package:flutter/material.dart';
import 'package:muslim_guide/quran/constant.dart';
import 'package:muslim_guide/screens/home_screen.dart';
import 'package:muslim_guide/screens/performance_screen.dart';
import 'package:muslim_guide/screens/schedule_screen.dart';
import 'package:muslim_guide/screens/settings_screen.dart';
import 'package:muslim_guide/quran/quran.dart';

class MuslimGuide extends StatefulWidget {
  const MuslimGuide({super.key});

  @override
  State<MuslimGuide> createState() {
    return _MuslimGuideState();
  }
}

class _MuslimGuideState extends State<MuslimGuide> {
  int activeScreen = 0;

  @override
  void initState() {
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      activeScreen = index;
    });
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        return PerformanceScreen();
      case 2:
        return ScheduleScreen();
      case 3:
        return Quran();
      case 4:
        return SettingsScreen();
      default:
        return HomeScreen();
    }
  }

  @override
  Widget build(context) {
    readBookmark();
    return MaterialApp(
      home: Scaffold(
        body: _getScreen(activeScreen),
        bottomNavigationBar: BottomNavigationBar(
          fixedColor: const Color.fromARGB(255, 30, 87, 32),
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          // Customize height
          iconSize: 24,
          onTap: _selectPage,
          currentIndex: activeScreen,
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
