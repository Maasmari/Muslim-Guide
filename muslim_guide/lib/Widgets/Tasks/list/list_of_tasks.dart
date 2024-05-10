import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muslim_guide/models/task.dart';
import 'package:muslim_guide/Widgets/Tasks/schedule_task.dart';
import 'package:muslim_guide/providers/task_provider.dart';
import 'package:muslim_guide/screens/forum_screen.dart';
import 'package:provider/provider.dart';

// This class is the same as task_item.dart but without the checkbox and with an add button
class ListofTaskItems extends StatelessWidget {
  const ListofTaskItems({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    const List<String> dayNames = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];

    void _openAddTaskOverlay() {
      showModalBottomSheet(
          context: context, builder: (ctx) => ScheduleTask(task: task));
    }

    void _assignTask(String userId, String taskId) {
      Provider.of<TaskProvider>(context, listen: false)
          .assignTask(userId, taskId);
      // Show a snackbar to confirm the task was added
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text('Task added!'),
          duration: const Duration(seconds: 2),
        ),
      );
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
        padding: const EdgeInsets.all(10), // More balanced padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
          children: [
            Row(
              children: [
                Text(
                  task.taskName,
                  style: const TextStyle(
                    color: Colors.white, // White text for contrast
                    fontSize: 20, // Larger font for emphasis
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    if (task.isAdjustable == 1) {
                      _openAddTaskOverlay();
                    } else {
                      _assignTask(
                          FirebaseAuth.instance.currentUser!.uid, task.id);
                    }
                  },
                  icon: task.isAdjustable == 1
                      ? Icon(Icons.add,
                          color: Colors
                              .white) // Show calendar icon if the task is adjustable
                      : Icon(Icons.add, color: Colors.white), // Add button
                  tooltip: 'Add Task', // Tooltip for better UX
                ),
              ],
            ),
            //const SizedBox(height: 8), // Slightly larger space
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.taskDescription,
                    style: const TextStyle(
                      color: Colors.white70, // Lighter white for description
                    ),
                    overflow: TextOverflow
                        .clip, // Clip the overflow if it's still too long even after wrapping
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForumWidget(
                                taskID: task.id, taskName: task.taskName)));
                  },
                  icon: const Icon(Icons.comment, color: Colors.white),
                  tooltip: 'View task forum', // Tooltip for better UX
                ),
              ],
            ),

            const SizedBox(height: 12), // Larger space before the row
            Row(
              children: [
                if (task.isAdjustable == 0)
                  Icon(
                    Icons.calendar_today, // Clock icon for time
                    color: Colors.white, // White icon for contrast
                  ),
                if (task.isAdjustable == 0)
                  Text(
                    '  ' +
                        task.taskFrequency
                            .toString()
                            .split('.')
                            .last, // Show frequency
                    style: const TextStyle(
                      color: Colors.white, // White text for contrast
                    ),
                  ),
                if (task.taskFrequency ==
                    TaskFrequency.weekly) // Only show day if weekly
                  Text(
                    ' every ${dayNames[task.day_of_week - 1]}', // Adjust index by -1 because lists are 0-indexed
                    style: const TextStyle(
                      color: Colors.white, // White text for contrast
                    ),
                  ),
                if (task.taskFrequency ==
                    TaskFrequency.monthly) // Only show day if monthly
                  Text(
                    ' on the ${task.day_of_month}th', // Show day of month
                    style: const TextStyle(
                      color: Colors.white, // White text for contrast
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
