import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:muslim_guide/Widgets/Tasks/task_item.dart';
import 'package:muslim_guide/models/task.dart';
import 'package:muslim_guide/providers/task_provider.dart';

class TasksList extends StatelessWidget {
    const TasksList({
    super.key,
    required this.tasks,
  });

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    // Fetch tasks directly from the provider
    //List<Task> tasks = Provider.of<TaskProvider>(context).assignedTasks;

    void CheckDateAndFrequency() { //this function changes the date of the task depending on its frequency.
      List<Task> tsks = Provider.of<TaskProvider>(context).assignedTasks;
      for(int i = 0 ; i < tsks.length ; i++) {

        if (tsks[i].taskFrequency == TaskFrequency.daily && tsks[i].date.day != DateTime.now().day) {
          tsks[i].date = DateTime.now();
        } else if (tsks[i].taskFrequency == TaskFrequency.weekly && tsks[i].date.difference(DateTime.now()).inDays > 7 ){
          tsks[i].date = tsks[i].date.add(const Duration(days: 7));
        } else if (tsks[i].taskFrequency == TaskFrequency.monthly) {
          if (tsks[i].date.month == 1 ||
              tsks[i].date.month == 3 ||
              tsks[i].date.month == 5 ||
              tsks[i].date.month == 7 ||
              tsks[i].date.month == 8 ||
              tsks[i].date.month == 10 ||
              tsks[i].date.month == 12 &&
              tsks[i].date.difference(DateTime.now()).inDays > 31) {
              tsks[i].date = tsks[i].date.add(const Duration(days: 31));
              } else if (tsks[i].date.month == 4 ||
              tsks[i].date.month == 6 ||
              tsks[i].date.month == 9 ||
              tsks[i].date.month == 11 &&
              tsks[i].date.difference(DateTime.now()).inDays > 30) {
              tsks[i].date = tsks[i].date.add(const Duration(days: 30));
              } else {
                if (tsks[i].date.year % 4 == 0 &&
                tsks[i].date.difference(DateTime.now()).inDays > 29) {
                //maybe needs adjustment, need to test 
                tsks[i].date = tsks[i].date.add(const Duration(days: 29));
                } else if (tsks[i].date.year % 4 != 0 &&
                tsks[i].date.difference(DateTime.now()).inDays > 28) {
                tsks[i].date = tsks[i].date.add(const Duration(days: 28));
                }
                }
        } else if (tsks[i].taskFrequency == TaskFrequency.yearly && tsks[i].date.difference(DateTime.now()).inDays > 365){
          tsks[i].date = tsks[i].date.add(const Duration(days: 365));
        }
      }
    }
    CheckDateAndFrequency();
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(tasks[index]),
        onDismissed: (direction) {
          // Call provider method to remove the task
          Provider.of<TaskProvider>(context, listen: false).removeTask(
              FirebaseAuth.instance.currentUser!.uid,
              tasks[index].id); // Assume removeTask takes task ID
        },
        child: TaskItem(task: tasks[index], key: UniqueKey()),
      ),
    );
  }
}
