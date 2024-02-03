import 'package:flutter/material.dart';
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
    Task(taskName: 'Surat Al Kahf', taskDescription: 'Read Surat Al Kahf.', taskType: TaskType.optional, taskFrequency: TaskFrequency.once)
  ];

  @override
  Widget build(context) {
    return const Scaffold(
      body: Column(
        children: [
          
        ],
      ),
    );
  }
}
