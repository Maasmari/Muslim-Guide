import 'package:flutter/material.dart';
import 'package:muslim_guide/Widgets/last_read_card.dart';
import 'package:muslim_guide/Widgets/task_card.dart';
import 'package:muslim_guide/Widgets/adhan_countdown.dart';
import 'package:muslim_guide/providers/task_provider.dart';
import 'package:muslim_guide/screens/my_tasks.dart';
import 'package:muslim_guide/screens/task_list_screen.dart';
import 'package:muslim_guide/widgets/prayer_times_card.dart';
import 'package:adhan/adhan.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  final Function? changeScreen;
  const HomeScreen({super.key, this.changeScreen});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  late Widget prayers;
  late Widget lastRead;

  @override
  void initState() {
    super.initState();
    prayers = PrayerTimeCard(city: 'Riyadh');
    // Assuming `widget.changeScreen` is the function you want to pass
    lastRead = LastReadCard(changeScreen: widget.changeScreen);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context,
        listen: true); // Access the ThemeProvider
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(30.0), // Set your desired height here
        child: AppBar(
          //title: Text('Muslim Guide'),
          backgroundColor:
              isDarkMode ? Color.fromARGB(255, 28, 28, 30) : Colors.white,

          centerTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AdhanCountdown(
              //coordinates: Coordinates(getLatitude(), getLongitude()),
              coordinates: Coordinates(24.7136, 46.6753),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: prayers,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  widget.changeScreen?.call(3);
                },
                child: lastRead,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyTasks()),
                  );
                },
                child: TaskCard(
                  title: 'My Tasks',
                  tasks: Provider.of<TaskProvider>(context, listen: true)
                      .assignedTasks,
                  color: isDarkMode
                      ? Color.fromARGB(255, 131, 3, 153)
                      : Color.fromARGB(255, 175, 32, 201),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  // Handle the tap event. Navigate, open a dialog, etc.
                  print('TaskCard tapped!');
                  // Example: Navigate to a new screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TaskListScreen()),
                  );
                },
                child: TaskCard(
                  title: 'Add More Tasks',
                  tasks: Provider.of<TaskProvider>(context, listen: true)
                      .unassignedTasks,
                  color: isDarkMode
                      ? Color.fromARGB(255, 0, 137, 164)
                      : Color.fromARGB(255, 32, 176, 201),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
