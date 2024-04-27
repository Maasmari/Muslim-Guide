import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:muslim_guide/widget_tree.dart';
import 'providers/task_provider.dart'; // Ensure you have this import pointing to your TaskProvider

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyB_fvadZ4e8ccKEXn8rKehJQOV_I_Rm6Ik",
        appId: "1:439190466191:android:812b97c2af1e5a00c70afa",
        messagingSenderId: "439190466191",
        projectId: "muslim-guide-417618",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) =>
                TaskProvider()), // Your TaskProvider or other providers
      ],
      child: MaterialApp(
        title: 'Muslim Guide',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home:
            const WidgetTree(), // Ensure this widget uses Provider if necessary
      ),
    );
  }
}
