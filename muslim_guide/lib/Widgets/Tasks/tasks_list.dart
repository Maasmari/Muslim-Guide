import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:muslim_guide/Widgets/Tasks/task_item.dart';
import 'package:muslim_guide/models/task.dart';
import 'package:muslim_guide/providers/task_provider.dart';

class TasksList extends StatelessWidget {
  const TasksList({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch tasks directly from the provider
    List<Task> tasks = Provider.of<TaskProvider>(context).assignedTasks;

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(tasks[index]),
        onDismissed: (direction) {
          // Call provider method to remove the task
          Provider.of<TaskProvider>(context, listen: false).removeTask(
              FirebaseAuth.instance.currentUser!.uid,
              tasks[index].id); // Assume removeTask takes task ID
        },
        child: TaskItem(task: tasks[index], key: UniqueKey()),
      ),
    );
  }
}
