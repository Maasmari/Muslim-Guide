import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:muslim_guide/Widgets/chart_bar.dart';
import 'package:muslim_guide/models/task.dart';
import 'package:muslim_guide/providers/completion_provider.dart';
import 'package:muslim_guide/providers/task_provider.dart';
import 'package:provider/provider.dart';

final DateFormat formatter = DateFormat('E');

Color determineBarColor(double fill) {
  if (fill >= 1.0) {
    return Color.fromARGB(255, 0, 133, 4); // Deep green
  } else if (fill >= 0.9) {
    return const Color.fromARGB(255, 50, 205, 50); // Lime green
  } else if (fill >= 0.8) {
    return Color.fromARGB(255, 64, 255, 47); // Green-yellow
  } else if (fill >= 0.7) {
    return const Color.fromARGB(255, 255, 255, 0); // Yellow
  } else if (fill >= 0.6) {
    return const Color.fromARGB(255, 255, 165, 0); // Orange
  } else if (fill >= 0.5) {
    return const Color.fromARGB(255, 255, 140, 0); // Dark orange
  } else if (fill >= 0.4) {
    return const Color.fromARGB(255, 255, 69, 0); // Red-orange
  } else if (fill >= 0.3) {
    return const Color.fromARGB(255, 255, 0, 0); // Red
  } else if (fill >= 0.2) {
    return const Color.fromARGB(255, 178, 34, 34); // Firebrick
  } else {
    return const Color.fromARGB(255, 139, 0, 0); // Dark red
  }
}

class Chart extends StatefulWidget {
  final DateTime startDate;

  const Chart({Key? key, required this.startDate}) : super(key: key);

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  late List<DateTime> days;
  Map<DateTime, int> maxTasksCache = {};
  Map<DateTime, int> completedTasksCache = {};

  @override
  void initState() {
    super.initState();
    _updateDaysList();
  }

  @override
  void didUpdateWidget(covariant Chart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.startDate != widget.startDate) {
      _updateDaysList();
    }
  }

  void _updateDaysList() {
    days = List.generate(
      7,
      (index) => widget.startDate.add(Duration(days: index)),
    );
    // Reorder the days list so that it starts from Sunday
    if (days.isNotEmpty && days.first.weekday != DateTime.sunday) {
      days.insert(0, days.removeLast());
    }
  }

  bool taskMatchesDate(Task task, DateTime date) {
    switch (task.taskFrequency) {
      case TaskFrequency.daily:
        return true;
      case TaskFrequency.weekly:
        int adjustedDayOfWeek = date.weekday == 7 ? 1 : date.weekday + 1;
        return task.day_of_week == adjustedDayOfWeek;
      case TaskFrequency.monthly:
        return task.day_of_month == date.day;
      case TaskFrequency.yearly:
        return task.day_of_month == date.day &&
            task.month_of_year == date.month;
      case TaskFrequency.once:
        return task.day_of_month == date.day &&
            task.month_of_year == date.month &&
            task.year == date.year;
      default:
        return false;
    }
  }

  Future<int> getMaxTasksForDay(DateTime date) async {
    final tasks =
        Provider.of<TaskProvider>(context, listen: false).assignedTasks;
    return tasks.where((task) => taskMatchesDate(task, date)).length;
  }

  Future<int> getCount(String userId, DateTime date) async {
    return await getCompletedTasksCount(
        FirebaseAuth.instance.currentUser!.uid, date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
            Theme.of(context).colorScheme.primary.withOpacity(0.0),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(days.length, (index) {
                return Expanded(
                  child: FutureBuilder<List<int>>(
                    future: Future.wait([
                      getCount(
                          FirebaseAuth.instance.currentUser!.uid, days[index]),
                      getMaxTasksForDay(days[index])
                    ]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        final int completedTasks = snapshot.data![0];
                        final int maxTasks = snapshot.data![1];
                        final double fill = maxTasks == 0
                            ? 0
                            : completedTasks / maxTasks.toDouble();
                        return ChartBar(
                          fill: fill,
                          color: determineBarColor(fill),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: days
                .map(
                  (day) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 4, 0),
                      child: Text(formatter.format(day)),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
