import 'package:flutter/material.dart';
import 'package:muslim_guide/screens/home_screen.dart';
import 'package:muslim_guide/screens/performance_screen.dart';
import 'package:muslim_guide/screens/schedule_screen.dart';
import 'package:muslim_guide/screens/settings_screen.dart';
import 'package:muslim_guide/quran/quran.dart';

class MuslimGuide extends StatefulWidget {
  const MuslimGuide({super.key});

  @override
  State<MuslimGuide> createState() => _MuslimGuideState();
}

class _MuslimGuideState extends State<MuslimGuide> {
  int activeScreen = 0;
  final List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    pages.add(HomeScreen(
        changeScreen:
            _selectPage)); // Assuming HomeScreen accepts and correctly handles changeScreen callback
    pages.add(PerformanceScreen());
    pages.add(const ScheduleScreen());
    pages.add(const Quran());
    pages.add(SettingsScreen());
  }

  void _selectPage(int index) {
    setState(() {
      activeScreen = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // For simplicity, user information retrieval has been removed. Implement as necessary.
    return MaterialApp(
      home: Scaffold(
        body: IndexedStack(
          index: activeScreen,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          fixedColor: const Color.fromARGB(255, 30, 87, 32),
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          iconSize: 24,
          onTap: _selectPage,
          currentIndex: activeScreen,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Performance',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Schedule',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_sharp),
              label: 'Quran',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
