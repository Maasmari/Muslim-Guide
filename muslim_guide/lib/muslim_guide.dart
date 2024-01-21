import 'package:flutter/material.dart';
import 'package:muslim_guide/screens/register_screen.dart';

class MuslimGuide extends StatefulWidget {
  const MuslimGuide({super.key});

  @override
  State<MuslimGuide> createState() {
    return _MuslimGuideState();
  }
}

class _MuslimGuideState extends State<MuslimGuide> {
  var activeScreen = 'login-screen';

  void switchScreen(String switchingScreen) { //maybe change the parameter or method
    setState(() {
      activeScreen = switchingScreen;
    });
  }

  @override
  Widget build(context) {
    return const MaterialApp(
      home: Scaffold(
        body: RegisterScreen(),
      ),
    );
  }
}