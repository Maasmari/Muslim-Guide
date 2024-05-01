import 'package:flutter/material.dart';
import 'package:muslim_guide/Widgets/checkbox.dart';
import 'package:muslim_guide/models/task.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5, // Adds shadow for a 3D effect
      margin: const EdgeInsets.all(8), // Uniform margin for better spacing
      color: const Color.fromARGB(255, 25, 85, 134), // More modern blue shade
      shape: RoundedRectangleBorder(
        // Rounded corners for a smoother look
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16), // More balanced padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
          children: [
            Text(
              task.taskName,
              style: const TextStyle(
                fontSize: 20, // Slightly smaller font size for subtlety
                fontWeight: FontWeight.bold, // Bold font for emphasis
                color: Colors.white, // White text for contrast
              ),
            ),
            const SizedBox(height: 8), // Slightly larger space
            Text(
              task.taskDescription,
              style: const TextStyle(
                color: Colors.white70, // Lighter white for description
              ),
            ),
            const SizedBox(height: 12), // Larger space before the row
            Row(
              children: [
                const Icon(Icons.alarm,
                    color: Colors.white70), // Icon color to match text
                const SizedBox(width: 8), // Slightly larger spacing
                Text(
                  task.time.format(context),
                  style: const TextStyle(
                      color: Colors.white), // Consistent text color
                ),
                const Spacer(),
                CheckboxTask(task: task), // Custom checkbox widget
                Text(
                  '(${task.taskFrequency.name.toUpperCase()})',
                  style: const TextStyle(
                      color: Colors.white), // Consistent text color
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
