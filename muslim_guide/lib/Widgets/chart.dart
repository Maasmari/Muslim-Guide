import 'package:flutter/material.dart';
import 'package:muslim_guide/Widgets/Tasks/tasks.dart';
import 'package:muslim_guide/Widgets/chart_bar.dart';
import 'package:muslim_guide/models/task.dart';

class Chart extends StatelessWidget {
  Chart({super.key});

  final List<Task> tasks = registeredTasks; 
  final List days = [' Sun', ' Mon', ' Tue', ' Wed', ' Thu', ' Fri', ' Sat'];

  // double get maxTotalExpense {
  //   double maxTotalExpense = 0;

  //   for (final task in tasks) {
  //     if (task.totalExpenses > maxTotalExpense) {
  //       maxTotalExpense = bucket.totalExpenses;
  //     }
  //   }

  //   return maxTotalExpense;
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
            Theme.of(context).colorScheme.primary.withOpacity(0.0)
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // ignore: unused_local_variable
                for (final day in days) // alternative to map()
                  ChartBar(
                    fill: 1,
                    color: Colors.red,
                  )
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: days
                .map(
                  (day) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(day),
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
