import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../auth.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  Future<void> signOut() async {
    await Auth().signOut();
  }

  void confirmSignOut(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Cancel'),
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
                  child: Text('Tap to log out',
                      style: TextStyle(color: Colors.red)),
                  onPressed: () => confirmSignOut(context),
                ),
              ),
              CupertinoFormRow(
                child: Column(children: [
                  Text('Dark/Light Mode'),
                  Text('Change your device from Dark/Light mode to switch.'),],),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
