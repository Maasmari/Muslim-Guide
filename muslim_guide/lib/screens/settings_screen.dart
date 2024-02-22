import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false; // Initial dark mode value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 30, 87, 32),
        ),
        body: ListView(
          children: <Widget>[
            CupertinoFormSection.insetGrouped(
              header: Text('General'),
              children: [
                CupertinoFormRow(
                  prefix: Text('Profile'),
                  child: CupertinoButton(
                    child: Text('View/Edit'),
                    onPressed: () {
                      // Navigate to profile view/edit screen
                    },
                  ),
                ),
                CupertinoFormRow(
                  prefix: Text('Dark Mode'),
                  child: CupertinoSwitch(
                    value: _darkMode,
                    onChanged: (bool value) {
                      setState(() {
                        _darkMode = value;
                      });
                      // Implement dark mode functionality here
                    },
                  ),
                ),
                CupertinoFormRow(
                  prefix: Text('Send Feedback'),
                  child: CupertinoButton(
                    child: Text('Go'),
                    onPressed: () {
                      // Implement feedback functionality here
                    },
                  ),
                ),
                CupertinoFormRow(
                  prefix: Text('Log Out'),
                  child: CupertinoButton(
                    child: Text('Tap to log out'),
                    onPressed: () {
                      // Implement logout functionality here
                    },
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
