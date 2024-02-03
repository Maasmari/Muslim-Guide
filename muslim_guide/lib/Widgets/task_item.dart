import 'package:flutter/material.dart';
import 'package:muslim_guide/models/task.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          children: [
            Text(task.taskName, style: const TextStyle(fontSize: 24),),
            const SizedBox(height: 4),
            Text(task.taskDescription),
            const SizedBox(height: 4),
            Text('(${task.taskFrequency.name.toUpperCase()})'),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.alarm),
                const SizedBox(width: 4),
                Text(task.formattedTime),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
