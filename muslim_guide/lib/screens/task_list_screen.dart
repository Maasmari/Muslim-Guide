import 'package:flutter/material.dart';
import 'package:muslim_guide/Widgets/Tasks/list/task_list.dart';

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
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add new tasks',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the color of icons to white
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 30, 87, 32),
      ),
      body: content(),
    );
  }

  Widget content() {
    return Padding(padding: const EdgeInsets.all(15.0), child: TaskList());
  }
}
