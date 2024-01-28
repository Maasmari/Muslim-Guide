import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() {
    return _SettingsState();
  }
}

class _SettingsState extends State<SettingsScreen> {
  bool isSwitched = false;

  @override
  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 30, 87, 32),
        ),
        body: Column(
          children: [
            Row(
              children: [
                const Text('Dark mode'),
                const Spacer(),
                Switch(
                  value: isSwitched,
                  onChanged: (value) { //need to make light theme and dark theme for dark/light mode
                    setState(
                      () {
                        isSwitched = value;
                      },
                    );
                  },
                )
              ],
            ),
            const Row(
              children: [
                Text('Send feedback'),
                Spacer(),
                Icon(Icons.arrow_right),
              ],
            ),
            const Row(
              children: [
                Text('Profile'),
                Spacer(),
                Icon(Icons.arrow_right),
              ],
            ),
            const Row(
              children: [
                Text(
                  'Logout',
                  style: TextStyle(color: Color.fromARGB(255, 202, 13, 0)),
                ),
                Spacer(),
                Icon(Icons.exit_to_app),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
