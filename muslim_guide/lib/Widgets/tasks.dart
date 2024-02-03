import 'package:flutter/material.dart';
import 'package:muslim_guide/Widgets/tasks_list.dart';
import 'package:muslim_guide/models/task.dart';

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<Tasks> createState() {
    return _TasksState();
  }
}

class _TasksState extends State<Tasks> {
  final List<Task> _registeredTasks = [
    Task(
        taskName: 'Surat Al Kahf',
        taskDescription: 'Read Surat Al Kahf.',
        taskType: TaskType.optional,
        taskFrequency: TaskFrequency.once,
        isCompleted: false),
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
        isCompleted: false)
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
      ),
      body: Column(
        children: [
          Expanded(
            child: TasksList(tasks: _registeredTasks),
          ),
        ],
      ),
    );
  }
}
