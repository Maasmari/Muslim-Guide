import 'package:flutter/material.dart';
import 'package:muslim_guide/models/task.dart';
import 'package:muslim_guide/screens/forum_screen.dart';

class MyTaskItem extends StatelessWidget {
  const MyTaskItem({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    //create a map of month names
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
                const SizedBox(width: 8), // Slightly larger spacing
                SizedBox(width: 8),
                if (task.taskFrequency == TaskFrequency.daily)
                  Text(
                    'Every Day',
                    style: const TextStyle(
                        color: Colors.white), // Consistent text color
                  ),
                if (task.taskFrequency == TaskFrequency.weekly)
                  //weekday is 1 = sunday and 2 = monday and so on
                  //transform the number to the name of the day
                  Text(
                    task.day_of_week == 1
                        ? 'Every Sunday'
                        : task.day_of_week == 2
                            ? 'Every Monday'
                            : task.day_of_week == 3
                                ? 'Every Tuesday'
                                : task.day_of_week == 4
                                    ? 'Every Wednesday'
                                    : task.day_of_week == 5
                                        ? 'Every Thursday'
                                        : task.day_of_week == 6
                                            ? 'Every Friday'
                                            : 'Every Saturday',
                    style: const TextStyle(
                        color: Colors.white), // Consistent text color
                  ),
                if (task.taskFrequency == TaskFrequency.monthly)
                  Text(
                    'Every Month on the ${task.day_of_month}th',
                    style: const TextStyle(
                        color: Colors.white), // Consistent text color
                  ),
                if (task.taskFrequency == TaskFrequency.yearly)
                  Text(
                    'Every Year on the ${task.day_of_month} of ${monthNames[task.month_of_year]}',
                    style: const TextStyle(
                        color: Colors.white), // Consistent text color
                  ),
                if (task.taskFrequency == TaskFrequency.once)
                  Text(
                    'Once on ${task.day_of_month}/${task.month_of_year}/${task.year}',
                    style: const TextStyle(
                        color: Colors.white), // Consistent text color
                  ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForumWidget(
                                taskID: task.id, taskName: task.taskName)));
                  },
                  icon: Icon(Icons.comment, color: Colors.white), // Add button
                  tooltip: 'View task forum', // Tooltip for better UX
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
