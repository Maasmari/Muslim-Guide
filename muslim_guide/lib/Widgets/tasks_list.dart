import 'package:flutter/material.dart';
import 'package:muslim_guide/models/task.dart';

class TasksList extends StatelessWidget {
  const TasksList({super.key, required this.tasks,});
  
  final List<Task> tasks;
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemCount: tasks.length,itemBuilder: (ctx, index) => Text(tasks[index].taskName),);
  }
}