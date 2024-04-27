import 'package:flutter/material.dart';
import 'package:muslim_guide/models/task.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final List<Task> tasks;
  final Color color;

  TaskCard({required this.title, required this.tasks, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0, // Optional: adds shadow to the card
      color: color,
      margin: const EdgeInsets.all(0.0), // Control the space around the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            10), // Optional: round the corners of the card
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0, vertical: 12.0), // Reduced vertical padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios,
                    color: Colors.white, size: 30.0),
              ],
            ),
            const SizedBox(height: 8.0), // Spacing between title and tasks
            ...tasks.take(3).map(
                  (task) => Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0), // Reduced spacing between tasks
                    child: Row(
                      children: [
                        Icon(
                          task.isCompleted
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: Colors.white,
                          size: 20.0, // Smaller icons
                        ),
                        const SizedBox(
                            width: 8.0), // Spacing between icon and text
                        Text(
                          task.taskName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize:
                                  14.0), // Smaller font size for task text
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
