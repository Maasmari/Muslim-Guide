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

class _TasksState extends State<Tasks> {
  final List<Task> _registeredTasks = [
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

  // void _openAddTaskOverlay() {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (ctx) => const Text('Modal bottom sheet'),
  //   );
  // }

  @override
  Widget build(context) {
     return 
    // Scaffold(    //MAYBE USE THIS IF ADMIN WANTS TO ADD A TASK
    //   appBar: AppBar(
    //     title: const Text(
    //       'List of scheduled tasks',
    //       style: TextStyle(color: Colors.white),
    //     ),
    //     backgroundColor: const Color.fromARGB(255, 30, 87, 32),
    //     actions: [
    //       IconButton.outlined(
    //         onPressed: _openAddTaskOverlay,
    //         icon: const Icon(Icons.add),
    //         color: Colors.white,
    //         highlightColor: const Color.fromARGB(255, 40, 116, 42),
    //       ),
    //     ],
    //   ),
    //   body:
      //Column(
        //children: [
          Expanded(
            child: TasksList(tasks: _registeredTasks),
          //),
        //],
     // ),
    );
  }
}
