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
        taskFrequency: TaskFrequency.weekly,
        isCompleted: false,
        date: DateTime.utc(2024, 4, 12),
        time: TimeOfDay(hour: 12, minute: 30),
        ),
    Task(
        taskName: 'Read Dua',
        taskDescription: 'Don\'t forget to read dua!',
        taskType: TaskType.optional,
        taskFrequency: TaskFrequency.daily,
        isCompleted: false,
        date: DateTime.utc(2024, 4, 11),
        time: TimeOfDay(hour: 20, minute: 0),
        ),
    Task(
        taskName: 'Fasting',
        taskDescription: 'Do not drink or eat until Adhan of Maghreb',
        taskType: TaskType.optional,
        taskFrequency: TaskFrequency.monthly,
        isCompleted: false,
        date: DateTime.utc(2024, 4, 15),
        time: TimeOfDay(hour: 4, minute: 0),
        ),
        Task(
        taskName: 'Sunnah prayer',
        taskDescription: 'Perform sunnah prayer',
        taskType: TaskType.optional,
        taskFrequency: TaskFrequency.daily,
        isCompleted: false,
        date: DateTime.utc(2024, 5, 13),
        time: TimeOfDay(hour: 20, minute: 0),
        ),
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
