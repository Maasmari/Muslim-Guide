import 'package:flutter/material.dart';
import 'package:muslim_guide/models/task.dart';
import 'package:muslim_guide/Widgets/Tasks/schedule_task.dart';

// This class is the same as task_item.dart but without the checkbox and with an add button
class ListofTaskItems extends StatelessWidget {
  const ListofTaskItems({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    void _openAddTaskOverlay() {
      showModalBottomSheet(
          context: context, builder: (ctx) => ScheduleTask(task: task));
    }

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
                const Spacer(),
                IconButton(
                  onPressed: _openAddTaskOverlay,
                  icon:
                      const Icon(Icons.add, color: Colors.white), // Add button
                  tooltip: 'Add Task', // Tooltip for better UX
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
