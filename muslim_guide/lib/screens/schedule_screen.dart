import 'package:flutter/material.dart';
import 'package:muslim_guide/Widgets/Tasks/tasks_list.dart';
import 'package:muslim_guide/models/task.dart';
import 'package:muslim_guide/providers/task_provider.dart';
import 'package:muslim_guide/screens/task_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleState();
}

class _ScheduleState extends State<ScheduleScreen> {
  DateTime today = DateTime.now();
  DateTime firstDate = DateTime(
      DateTime.now().year - 1, DateTime.now().month, DateTime.now().day);
  DateTime lastDate = DateTime(
      DateTime.now().year + 1, DateTime.now().month, DateTime.now().day);
  Map<DateTime, List<Task>> tasks = {};
  late final ValueNotifier<List<Task>> _selectedTasks;
  List<Task> assignedTasks = [];

  @override
  void initState() {
    super.initState();
    _selectedTasks =
        ValueNotifier<List<Task>>([]); // Initialized with an empty list.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final taskProvider = Provider.of<TaskProvider>(context, listen: false);
        assignedTasks = taskProvider.assignedTasks;
        _selectedTasks.value =
            _getTasksForDay(today); // Now safely updating the value.
      }
    });
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
    _selectedTasks.value = _getTasksForDay(day);
  }

  List<Task> _getTasksForDay(DateTime day) {
    return assignedTasks.where((task) {
      switch (task.taskFrequency) {
        case TaskFrequency.daily:
          return true; // Show daily tasks every day
        case TaskFrequency.weekly:
          return task.day_of_week ==
              day.weekday; // Show weekly tasks on specified day
        case TaskFrequency.monthly:
          return task.day_of_month ==
              day.day; // Show monthly tasks on specified day of month
        default:
          return false; // For other frequencies (yearly, once, etc.), don't show on this day
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to TaskProvider directly in the build method
    final taskProvider = Provider.of<TaskProvider>(context);
    assignedTasks = taskProvider
        .assignedTasks; // This line will cause the widget to rebuild when assignedTasks changes

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 30, 87, 32),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const TaskListScreen())),
              icon: const Icon(Icons.add, color: Colors.white))
        ],
      ),
      body: content(),
    );
  }

  Widget content() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          TableCalendar(
            focusedDay: today,
            firstDay: firstDate,
            lastDay: lastDate,
            locale: 'en_US',
            headerStyle: const HeaderStyle(
                formatButtonVisible: false, titleCentered: true),
            availableGestures: AvailableGestures.all,
            onDaySelected: _onDaySelected,
            selectedDayPredicate: (day) => isSameDay(day, today),
            eventLoader: (day) => <dynamic>[],
          ),
          const Divider(color: Colors.black, thickness: 2),
          Expanded(
            child: ValueListenableBuilder<List<Task>>(
              valueListenable: _selectedTasks,
              builder: (context, value, _) {
                return TasksList(tasks: _getTasksForDay(today));
              },
            ),
          ),
        ],
      ),
    );
  }
}
