import 'package:flutter/material.dart';
import 'package:muslim_guide/Widgets/Tasks/tasks_list.dart';

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TasksList(),
    );
  }
}
