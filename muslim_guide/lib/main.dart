import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:muslim_guide/muslim_guide.dart';
import 'package:muslim_guide/widget_tree.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muslim Guide',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const WidgetTree(),
    );
  }
}
