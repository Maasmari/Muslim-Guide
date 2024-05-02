import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:muslim_guide/providers/theme_provider.dart';
import 'package:muslim_guide/screens/profile_screen.dart';
import 'package:muslim_guide/screens/write_suggestion_screen.dart';
import 'package:provider/provider.dart';
import '../database/auth.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> signOut() async {
    await Auth().signOut();
  }

  void confirmSignOut(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            'Confirm Logout',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Cancel',
                  style:
                      TextStyle(color: isDarkMode ? Colors.blue : Colors.blue)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            CupertinoDialogAction(
              child: Text('Log Out', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog first
                signOut(); // Then sign out
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context,
        listen: true); // Access the ThemeProvider

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings',
            style: TextStyle(color: Colors.white, fontSize: 23)),
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
                  child: Text('View'),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ProfileScreen()));
                  },
                ),
              ),
              CupertinoFormRow(
                prefix: Text('Suggest a task'),
                child: CupertinoButton(
                  child: Text('Go'),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const WriteSuggestionScreen()));
                  },
                ),
              ),
              CupertinoFormRow(
                prefix: Text('Log Out'),
                child: CupertinoButton(
                  child: Text('Tap to log out',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 255, 38, 23))),
                  onPressed: () => confirmSignOut(context),
                ),
              ),
              CupertinoFormRow(
                prefix: Text('Dark Mode'),
                child: CupertinoSwitch(
                  value: themeProvider.themeMode == ThemeMode.dark,
                  onChanged: (bool value) {
                    themeProvider.toggleTheme(value);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
