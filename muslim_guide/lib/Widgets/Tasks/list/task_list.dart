import 'package:flutter/material.dart';
import 'package:muslim_guide/Widgets/Tasks/list/list_of_tasks.dart';
import 'package:muslim_guide/models/task.dart';
import 'package:muslim_guide/providers/task_provider.dart';
import 'package:provider/provider.dart';

//same as tasks_list.dart class but for list_of_tasks.dart
class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Task> tasks =
        Provider.of<TaskProvider>(context, listen: true).unassignedTasks;
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (ctx, index) => ListofTaskItems(task: tasks[index]),
    );
  }
}
