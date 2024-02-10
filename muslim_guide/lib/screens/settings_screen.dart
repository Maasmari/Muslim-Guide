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
          title: const Text('Settings', style: TextStyle(color: Colors.white),),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 30, 87, 32),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const Text('To enable Dark/Light mode, change your systems Dark/Light mode setting.'),
              const Divider(color: Colors.black),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Text('Send feedback'),
                  const Spacer(),
                  IconButton.outlined(onPressed: () {}, icon: const Icon(Icons.arrow_right)),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.black),
              Row(
                children: [
                  const Text('Profile'),
                  const Spacer(),
                  IconButton.outlined(onPressed: () {}, icon: const Icon(Icons.account_circle)),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.black),
              Row(
                children: [
                  const Text(
                    'Logout',
                    style: TextStyle(color: Color.fromARGB(255, 202, 13, 0)),
                  ),
                  const Spacer(),
                  IconButton.outlined(onPressed: () {}, icon: const Icon(Icons.exit_to_app_rounded)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
