import 'package:flutter/material.dart';
import 'package:muslim_guide/models/task.dart';

//this class is the same as task_item.dart but without the checkbox and with an add button
class ListofTaskItems extends StatelessWidget {
  const ListofTaskItems({super.key, required this.task});

  final Task task;
  
  @override
  Widget build(BuildContext context) {

    void _presentDatePicker() {
      final now = DateTime.now();
      DateTime firstDate = DateTime(DateTime.now().year - 1, DateTime.now().month, DateTime.now().day);
      DateTime lastDate = DateTime(DateTime.now().year + 1, DateTime.now().month, DateTime.now().day);
      showDatePicker(context: context, firstDate: firstDate, lastDate: lastDate, initialDate: now);
    }

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
                const Spacer(),
                IconButton.filled(
                  onPressed: () {
                    _presentDatePicker();
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
