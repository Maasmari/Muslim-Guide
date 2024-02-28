import 'package:flutter/material.dart';
import 'package:muslim_guide/Widgets/Tasks/tasks_list.dart';
import 'package:muslim_guide/models/task.dart';

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<Tasks> createState() {
    return _TasksState();
  }
}
final List<Task> registeredTasks = [ //was a private list
    Task(
        taskName: 'Surat Al Kahf',
        taskDescription: 'Read Surat Al Kahf.',
        taskType: TaskType.optional,
        taskFrequency: TaskFrequency.once,
        isCompleted: false,
        ),
    Task(
        taskName: 'Read Dua',
        taskDescription: 'Don\'t forget to read dua!',
        taskType: TaskType.optional,
        taskFrequency: TaskFrequency.daily,
        isCompleted: false),
    Task(
        taskName: 'Fasting',
        taskDescription: 'Do not drink or eat until Adhaan Al Maghreb!',
        taskType: TaskType.optional,
        taskFrequency: TaskFrequency.monthly,
        isCompleted: false)
  ];
class _TasksState extends State<Tasks> {
  
  @override
  Widget build(context) {
     return 
          Expanded(
            child: TasksList(tasks: registeredTasks),
    );
  }
}
