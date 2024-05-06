import 'package:flutter/material.dart';
import 'package:muslim_guide/Widgets/Tasks/my_tasks_list.dart';
import 'package:muslim_guide/models/task.dart';
import 'package:muslim_guide/providers/task_provider.dart';
import 'package:provider/provider.dart';

//similar to tasks.dart
class MyTasks extends StatefulWidget {
  //MyTasks()
  const MyTasks({super.key});

  @override
  State<MyTasks> createState() {
    return _MyTasks();
  }
}

class _MyTasks extends State<MyTasks> {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Tasks',
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
    List<Task> tasks =
        Provider.of<TaskProvider>(context, listen: true).assignedTasks;
    return Padding(
        padding: const EdgeInsets.all(15.0), child: MyTasksList(tasks: tasks));
  }
}
