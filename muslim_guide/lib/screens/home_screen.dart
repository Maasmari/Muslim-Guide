import 'package:flutter/material.dart';
import 'package:muslim_guide/Widgets/last_read_card.dart';
import 'package:muslim_guide/Widgets/task_card.dart';
import 'package:muslim_guide/Widgets/adhan_countdown.dart';
import 'package:muslim_guide/models/task.dart';
import 'package:muslim_guide/widgets/prayer_times_card.dart';
import 'package:adhan/adhan.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  Widget prayers = PrayerTimeCard(city: 'Riyadh');

  Widget lastRead = LastReadCard(
    lastRead: LastRead(
      title: 'Al-Baqarah',
      verseNumber: 285,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AdhanCountdown(
          //coordinates: Coordinates(getLatitude(), getLongitude()),
          coordinates: Coordinates(24.7136, 46.6753),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                tasks: [
                  Task(
                    taskName: 'Surat Al Kahf',
                    taskDescription: 'Read Surat Al Kahf.',
                    taskType: TaskType.optional,
                    taskFrequency: TaskFrequency.once,
                    isCompleted: true,
                  ),
                  Task(
                    taskName: 'Read Dua',
                    taskDescription: 'Don\'t forget to read dua!',
                    taskType: TaskType.optional,
                    taskFrequency: TaskFrequency.daily,
                    isCompleted: false,
                  ),
                  Task(
                    taskName: 'Fasting',
                    taskDescription:
                        'Do not drink or eat until Adhaan Al Maghreb!',
                    taskType: TaskType.optional,
                    taskFrequency: TaskFrequency.monthly,
                    isCompleted: false,
                  ),
                ],
                color: Colors.purple,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TaskCard(
                title: 'Optional Tasks',
                tasks: [
                  Task(
                    taskName: 'Surat Al Kahf',
                    taskDescription: 'Read Surat Al Kahf.',
                    taskType: TaskType.optional,
                    taskFrequency: TaskFrequency.once,
                    isCompleted: false,
                  ),
                  Task(
                    taskName: 'Read Dua',
                    taskDescription: 'Don\'t forget to read dua!',
                    taskType: TaskType.optional,
                    taskFrequency: TaskFrequency.daily,
                    isCompleted: false,
                  ),
                  Task(
                    taskName: 'Fasting',
                    taskDescription:
                        'Do not drink or eat until Adhaan Al Maghreb!',
                    taskType: TaskType.optional,
                    taskFrequency: TaskFrequency.monthly,
                    isCompleted: false,
                  ),
                ],
                color: Color.fromARGB(255, 31, 175, 195),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
