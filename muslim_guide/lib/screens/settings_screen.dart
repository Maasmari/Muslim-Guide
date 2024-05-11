import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:muslim_guide/providers/theme_provider.dart';
import 'package:muslim_guide/screens/my_forum_screen.dart';
import 'package:muslim_guide/screens/suggestion_screen.dart';
import 'package:muslim_guide/screens/write_suggestion_screen.dart';
import 'package:provider/provider.dart';
import '../database/auth.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  User? user = FirebaseAuth.instance.currentUser;

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
              child: Text('Cancel', style: TextStyle(color: Colors.blue)),
              onPressed: () => Navigator.of(context).pop(),
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
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    String displayName = user?.displayName ?? "No username";
    String email = user?.email ?? "No email provided";

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Settings',
            style: TextStyle(color: Colors.white, fontSize: 23)),
        backgroundColor: const Color.fromARGB(255, 30, 87, 32),
      ),
      body: ListView(
        children: <Widget>[
          CupertinoFormSection.insetGrouped(
            margin: EdgeInsets.fromLTRB(10, 20, 10, 5),
            children: [
              CupertinoFormRow(
                prefix: Text('Username'),
                child: CupertinoButton(
                  child: Text('@' + displayName,
                      style:
                          TextStyle(color: Color.fromARGB(255, 144, 145, 145))),
                  onPressed: () {},
                ),
              ),
              CupertinoFormRow(
                prefix: Text('Email'),
                child: CupertinoButton(
                  child: Text(email,
                      style: TextStyle(
                          color: const Color.fromARGB(255, 144, 145, 145))),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          CupertinoFormSection.insetGrouped(
            margin: EdgeInsets.fromLTRB(10, 20, 10, 5),
            children: [
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
                prefix: Text('My Seggestions'),
                child: CupertinoButton(
                  child: Text('View'),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SuggestionsScreen()));
                  },
                ),
              ),
              CupertinoFormRow(
                prefix: Text('My Comments and Replies'),
                child: CupertinoButton(
                  child: Text('View'),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MyForumWidget()));
                  },
                ),
              ),
            ],
          ),
          CupertinoFormSection.insetGrouped(
            margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
            children: [
              // CupertinoFormRow(
              //   prefix: Text('Profile'),
              //   child: CupertinoButton(
              //     child: Text('View'),
              //     onPressed: () {
              //       Navigator.of(context).push(MaterialPageRoute(
              //           builder: (context) => const ProfileScreen()));
              //     },
              //   ),
              // ),

              CupertinoFormRow(
                prefix: Text('Dark Mode'),
                child: CupertinoSwitch(
                  value: themeProvider.themeMode == ThemeMode.dark,
                  onChanged: (bool value) {
                    themeProvider.toggleTheme(value);
                  },
                ),
              ),
              CupertinoFormRow(
                prefix: Text('Log Out'),
                child: CupertinoButton(
                  child: Text('Tap to log out',
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 38, 23))),
                  onPressed: () => confirmSignOut(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
