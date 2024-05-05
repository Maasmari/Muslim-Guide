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

    void CheckDateAndFrequency() {
      //this function changes the date of the task depending on its frequency.
      List<Task> tsks = Provider.of<TaskProvider>(context).assignedTasks;
      for (int i = 0; i < tsks.length; i++) {
        if (tsks[i].taskFrequency == TaskFrequency.daily &&
            tsks[i].date.day != DateTime.now().day) {
          tsks[i].date = DateTime.now();
        } else if (tsks[i].taskFrequency == TaskFrequency.weekly &&
            tsks[i].date.difference(DateTime.now()).inDays > 7) {
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
        } else if (tsks[i].taskFrequency == TaskFrequency.yearly &&
            tsks[i].date.difference(DateTime.now()).inDays > 365) {
          tsks[i].date = tsks[i].date.add(const Duration(days: 365));
        } else if (tsks[i].taskFrequency == TaskFrequency.once &&
            tsks[i].date.difference(DateTime.now()).inDays > 365) {
          tsks.remove(tsks[
              i]); //REMOVE TASK IF ITS OLDER THAN 1 YEAR, NEED TO REMOVE FROM DB
        }
      }
    }

    CheckDateAndFrequency();
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(
            tasks[index].id), // Use task.id for a unique key if available
        background: Container(
          margin: EdgeInsets.all(8), // Add margin to the container
          color: Colors.red, // Red background indicates a delete action
          child: Align(
            alignment:
                Alignment.centerRight, // Icon aligned to the right on swipe
            child: Padding(
              padding: EdgeInsets.only(right: 20.0), // Right padding
              child:
                  Icon(Icons.delete, color: Colors.white), // White delete icon
            ),
          ),
        ),
        direction:
            DismissDirection.endToStart, // Only allow swiping in one direction
        confirmDismiss: (direction) async {
          if (tasks[index].taskType == TaskType.compulsory) {
            ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                  'This task is compulsory and cannot be deleted'), // Show error message
              duration: Duration(
                  seconds: 2), // Optional: adjust duration of the snack bar
            ));
            return false; // Prevent dismiss
          }
          return true; // Allow dismiss for non-compulsory tasks
        },
        onDismissed: (direction) {
          // Call provider method to remove the task
          Provider.of<TaskProvider>(ctx, listen: false).removeTask(
              FirebaseAuth.instance.currentUser!.uid,
              tasks[index].id); // Assume removeTask takes task ID
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
              backgroundColor: Colors.green,
              content: Text('Task deleted') // Show confirmation message
              ));
        },
        child: TaskItem(
            task: tasks[index], key: UniqueKey()), // Render each task item
      ),
    );
  }
}
