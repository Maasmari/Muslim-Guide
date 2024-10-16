import 'package:flutter/material.dart';
import 'package:muslim_guide/Widgets/Tasks/tasks_list.dart';
import 'package:muslim_guide/models/task.dart';
import 'package:muslim_guide/providers/task_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Tasks extends StatefulWidget {
  Tasks({super.key, required this.now});
  DateTime now;

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  @override
  Widget build(BuildContext context) {
    List<Task> assignedTasks =
        Provider.of<TaskProvider>(context, listen: true).assignedTasks;
    return Expanded(
      child: TasksList(tasks: assignedTasks, now: widget.now),
    );
  }
}
