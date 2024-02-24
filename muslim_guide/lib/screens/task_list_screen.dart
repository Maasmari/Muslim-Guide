import 'package:flutter/material.dart';
import 'package:muslim_guide/Widgets/Tasks/list/task_list.dart';
import 'package:muslim_guide/models/task.dart';

//similar to tasks.dart
class TaskListScreen extends StatefulWidget {
  //TaskListScreen()
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() {
    return _TaskListState();
  }
}

class _TaskListState extends State<TaskListScreen> {
  final List<Task> listOfTasks = [
    //was a private list
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
        isCompleted: false),
    Task(
        taskName: 'Fasting',
        taskDescription: 'Do not drink or eat until Adhaan Al Maghreb!',
        taskType: TaskType.optional,
        taskFrequency: TaskFrequency.monthly,
        isCompleted: false),
    Task(
        taskName: 'Sunnah',
        taskDescription: 'Perform sunnah prayer.',
        taskType: TaskType.optional,
        taskFrequency: TaskFrequency.daily,
        isCompleted: false),
  ];

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'List of tasks',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 30, 87, 32),
        leading: IconButton(
            onPressed: () {} /* change active screen to ScheduleScreen() */,
            icon: const Icon(Icons.arrow_back)),
      ),
      body: content(),
    );
  }

  Widget content() {
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: TaskList(tasks: listOfTasks));
  }
}
