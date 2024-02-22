import 'package:flutter/material.dart';
import 'package:muslim_guide/Widgets/Tasks/list/list_of_tasks.dart';
import 'package:muslim_guide/models/task.dart';
//same as tasks_list.dart class but for list_of_tasks.dart
class TaskList extends StatelessWidget {
  const TaskList({super.key, required this.tasks,});
  
  final List<Task> tasks;
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemCount: tasks.length,itemBuilder: (ctx, index) => ListofTaskItems(task: tasks[index]),);
  }
}