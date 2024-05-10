import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muslim_guide/models/task.dart';
import 'package:muslim_guide/providers/completion_provider.dart';

class PerformanceTaskItem extends StatelessWidget {
  final Task task;
  final DateTime now;
  final Map<int, String> monthNames = {
    1: 'January',
    2: 'February',
    3: 'March',
    4: 'April',
    5: 'May',
    6: 'June',
    7: 'July',
    8: 'August',
    9: 'September',
    10: 'October',
    11: 'November',
    12: 'December',
  };
  PerformanceTaskItem({Key? key, required this.task, required this.now})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkTaskCompletion(
          FirebaseAuth.instance.currentUser!.uid, task.id, now),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center();
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else {
          final bool isCompleted = snapshot.data ?? false;
          return Card(
            elevation: 5,
            margin: const EdgeInsets.all(8),
            color: isCompleted
                ? Color.fromARGB(255, 10, 141, 14)
                : Color.fromARGB(255, 210, 21, 7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        task.taskName,
                        style: const TextStyle(
                          color: Colors.white, // White text for better contrast
                          fontWeight: FontWeight.bold, // Bold for emphasis
                          fontSize:
                              20, // Larger font size for better readability
                        ),
                      ), // Spacing between text and icon
                      const Spacer(),
                      const Icon(Icons.alarm,
                          color: Colors.white70), // Icon color to match text
                      const SizedBox(width: 8), // Slightly larger spacing
                      Text(
                        task.time.format(context),
                        style: const TextStyle(
                            color: Colors.white), // Consistent text color
                      ),
                    ],
                  ),
                  //const SizedBox(height: 8), // Slightly larger space
                  // Larger space before the row
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
