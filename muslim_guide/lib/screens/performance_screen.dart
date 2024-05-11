import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:muslim_guide/Widgets/Tasks/performance_task_list.dart';
import 'package:muslim_guide/Widgets/chart.dart';
import 'package:muslim_guide/models/task.dart';
import 'package:muslim_guide/providers/task_provider.dart';
import 'package:provider/provider.dart';

final DateFormat formatterYMD = DateFormat.yMEd();

class PerformanceScreen extends StatefulWidget {
  @override
  _PerformanceScreenState createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  late DateTime _startDate;
  DateTime _selectedDay = DateTime.now(); // Initialized with current date
  List<Task> assignedTasks = [];
  late final ValueNotifier<List<Task>> _selectedTasks;

  @override
  void initState() {
    super.initState();
    _calculateStartDate();
    _selectedTasks = ValueNotifier<List<Task>>([]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        try {
          final taskProvider =
              Provider.of<TaskProvider>(context, listen: false);
          assignedTasks = taskProvider.assignedTasks;
          _selectedDay = DateTime.now(); // Adjust as necessary
          _handleDaySelected(_selectedDay);
          _selectedTasks.value = _getTasksForDay(_selectedDay);
        } catch (e) {
          print('Error initializing tasks: $e');
        }
      }
    });
  }

  void _calculateStartDate() {
    //find this sunday
    DateTime now = DateTime.now();
    _startDate = now.subtract(Duration(days: now.weekday));
  }

  void _navigateToPreviousWeek() {
    setState(() {
      _startDate = _startDate.subtract(Duration(days: 7));
      _selectedTasks.value = _getTasksForDay(_startDate);
    });
  }

  void _navigateToNextWeek() {
    setState(() {
      DateTime nextStartDate = _startDate.add(Duration(days: 7));
      if (!nextStartDate.isAfter(DateTime.now())) {
        _startDate = nextStartDate;
        _selectedTasks.value = _getTasksForDay(_startDate);
      }
    });
  }

  String _getWeekText() {
    DateTime endDate = _startDate.add(Duration(days: 6));
    return '${formatterYMD.format(_startDate)} - ${formatterYMD.format(endDate)}';
  }

  void _handleDaySelected(DateTime day) {
    setState(() {
      _selectedDay = day;
      _selectedTasks.value =
          _getTasksForDay(day); // Update the tasks for the selected day
    });
  }

  List<Task> _getTasksForDay(DateTime day) {
    var filteredTasks = assignedTasks.where((task) {
      switch (task.taskFrequency) {
        case TaskFrequency.daily:
          return true;
        case TaskFrequency.weekly:
          int adjustedDayOfWeek = day.weekday == 7 ? 1 : day.weekday + 1;
          return task.day_of_week == adjustedDayOfWeek;
        case TaskFrequency.monthly:
          return task.day_of_month == day.day;
        case TaskFrequency.yearly:
          return task.day_of_month == day.day &&
              task.month_of_year == day.month;
        default:
          return false;
      }
    }).toList();

    return filteredTasks;
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    assignedTasks = taskProvider.assignedTasks;
    _selectedTasks.value = _getTasksForDay(_selectedDay);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Performance',
            style: TextStyle(color: Colors.white, fontSize: 23)),
        backgroundColor: Color.fromARGB(255, 30, 87, 32),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_left),
                    onPressed: _navigateToPreviousWeek),
                Text(_getWeekText(),
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(
                    icon: Icon(Icons.arrow_right),
                    onPressed: _navigateToNextWeek),
              ],
            ),
            SizedBox(height: 20),
            Chart(
                startDate: _startDate,
                onDaySelected:
                    _handleDaySelected), // Ensure this widget uses the callback correctly
            SizedBox(height: 10),
            //put the selected day here as 15/10/2021
            Text(formatterYMD.format(_selectedDay),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: ValueListenableBuilder<List<Task>>(
                valueListenable: _selectedTasks,
                builder: (context, value, _) {
                  return PerformanceTasksList(
                      tasks: value,
                      now:
                          _selectedDay); // Ensure this widget is implemented to display tasks
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
