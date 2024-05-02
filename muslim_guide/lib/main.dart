import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:muslim_guide/widget_tree.dart';
import 'providers/task_provider.dart';
import 'providers/theme_provider.dart'; // Ensure this is the correct path to your ThemeProvider

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
    final brightness = MediaQuery.of(context).platformBrightness;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(
            create: (_) =>
                ThemeProvider(brightness: brightness)), // Add this line
      ],
      child: Consumer<ThemeProvider>(
        // Use Consumer to listen for changes
        builder: (context, themeProvider, _) {
          print(
              "Rebuilding MaterialApp with ThemeMode: ${themeProvider.themeMode}");
          print("Current Theme Mode: ${themeProvider.themeMode}");
          print("Light Theme Data: ${ThemeData.light().toString()}");
          print("Dark Theme Data: ${ThemeData.dark().toString()}");
          return MaterialApp(
            title: 'Muslim Guide',
            theme: ThemeData(
              primarySwatch: Colors.green,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.green,
              brightness: Brightness.dark,
            ),
            themeMode:
                themeProvider.themeMode, // Controlled by the themeProvider
            home: const WidgetTree(),
          );
        },
      ),
    );
  }
}
