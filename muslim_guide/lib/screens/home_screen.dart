import 'package:flutter/material.dart';
import 'package:muslim_guide/Widgets/Tasks/tasks.dart';
import 'package:muslim_guide/Widgets/last_read_card.dart';
import 'package:muslim_guide/Widgets/task_card.dart';
import 'package:muslim_guide/Widgets/adhan_countdown.dart';
import 'package:muslim_guide/widgets/prayer_times_card.dart';
import 'package:adhan/adhan.dart';

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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(30.0), // Set your desired height here
        child: AppBar(
          //title: Text('Muslim Guide'),

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
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: prayers,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: lastRead,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TaskCard(
                title: 'Your Tasks',
                tasks: registeredTasks.sublist(0, 3),
                color: Colors.purple,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TaskCard(
                title: 'Optional Tasks',
                tasks: registeredTasks.sublist(0, 3),
                color: Color.fromARGB(255, 31, 175, 195),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
