import 'package:flutter/material.dart';
import 'package:muslim_guide/Widgets/chart_bar.dart';
import 'package:muslim_guide/models/task.dart';
import 'package:muslim_guide/providers/task_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

final DateFormat formatter = DateFormat.E();

// List<Task> getCompletedTasks() {
//   List<Task> completed = [];
//   for(int i = 0; i < registeredTasks.length; i++){
//     if(registeredTasks[i].isCompleted){
//       completed.add(registeredTasks[i]);
//     }
//    }
//   return completed;
// }

class Chart extends StatelessWidget {
  Chart({super.key});

  // final List<Task> tasks = [];
  final List days = [formatter.format(DateTime.now().subtract(const Duration(days: 6))),
    formatter.format(DateTime.now().subtract(const Duration(days: 5))),
    formatter.format(DateTime.now().subtract(const Duration(days: 4))),
    formatter.format(DateTime.now().subtract(const Duration(days: 3))),
    formatter.format(DateTime.now().subtract(const Duration(days: 2))),
    formatter.format(DateTime.now().subtract(const Duration(days: 1))),
    formatter.format(DateTime.now())];
  // final List<Task> completedtasks = getCompletedTasks();

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
    List<Task> MyTasks = Provider.of<TaskProvider>(context).assignedTasks;

    List<Task> getCompletedTasks() {
      List<Task> completed = [];
      for(int i = 0; i < MyTasks.length; i++){
        if(MyTasks[i].isCompleted){
          completed.add(MyTasks[i]);
        }
      }
      return completed;
    }

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
                    color: Color.fromARGB(255, 199, 119, 0),
                  )
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children:
            days.map(
                  (day) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 4, 0),
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
