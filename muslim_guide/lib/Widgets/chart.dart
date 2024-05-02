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
  final List days = [
    DateTime.now().subtract(const Duration(days: 6)),
    DateTime.now().subtract(const Duration(days: 5)),
    DateTime.now().subtract(const Duration(days: 4)),
    DateTime.now().subtract(const Duration(days: 3)),
    DateTime.now().subtract(const Duration(days: 2)),
    DateTime.now().subtract(const Duration(days: 1)),
    DateTime.now()];
  // final List<Task> completedtasks = getCompletedTasks();

  @override
  Widget build(BuildContext context) {
    List<Task> MyTasks = Provider.of<TaskProvider>(context).assignedTasks;
    
    double maxTotalTasksInADay() { //might be slow but it should work
      double max = 0;
      double counter = 0;
      for(int i = 0; i < 7; i++) {
        for(int j = 0; j < MyTasks.length; j++) {
          if(MyTasks[j].date == DateTime.now().subtract(Duration(days: i))) {
            ++counter;
          }
        }
        if(counter > max) {
          max = counter;
        }
        counter = 0;
      }
     return max;
    }
    double maxTotalTasksInDay = maxTotalTasksInADay();

    List<Task> getCompletedTasks(DateTime day) {
      List<Task> completed = [];
      for(int i = 0; i < MyTasks.length; i++){
        if(MyTasks[i].date == day && MyTasks[i].isCompleted){
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
                    fill: getCompletedTasks(day).length == 0 ? 0 : getCompletedTasks(day).length / maxTotalTasksInDay,
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
                      child: Text(formatter.format(day)),
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
