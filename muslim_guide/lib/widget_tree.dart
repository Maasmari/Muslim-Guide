import 'package:flutter/material.dart';
import 'package:muslim_guide/database/auth.dart';
import 'package:muslim_guide/muslim_guide.dart';
import 'package:muslim_guide/screens/login_screen.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() {
    return _WidgetTreeState();
  }
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MuslimGuide();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
