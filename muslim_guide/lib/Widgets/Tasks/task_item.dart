import 'package:flutter/material.dart';
import 'package:muslim_guide/Widgets/checkbox.dart';
import 'package:muslim_guide/models/task.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 9, 91, 185),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          children: [
            Text(
              task.taskName,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 4),
            Text(task.taskDescription),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.alarm),
                const SizedBox(width: 4),
                Text(task.time.format(context)),
                const Spacer(),
                CheckboxTask(task: task),
                //Text('(${task.taskFrequency.name.toUpperCase()})'), THIS DISPLAY THE FREQUENCY OF THE TASK
              ],
            ),
          ],
        ),
      ),
    );
  }
}
