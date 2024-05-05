import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/task_provider.dart';
import '../models/task.dart'; // Assuming your Task class is in this file

class TaskScreenDB extends StatefulWidget {
  @override
  _TaskScreenDBState createState() => _TaskScreenDBState();
}

class _TaskScreenDBState extends State<TaskScreenDB> {
  @override
  void initState() {
    super.initState();
    initTasks();
  }

  void initTasks() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = await auth.currentUser;
    if (user != null) {
      String userID = user.uid;
      Provider.of<TaskProvider>(context, listen: false)
        ..fetchUnassignedTasks(userID)
        ..setAssignedTasks(userID);
    } else {
      print('User not signed in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Tasks', style: TextStyle(color: Colors.white, fontSize: 23)),
        backgroundColor: const Color.fromARGB(255, 30, 87, 32),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Compulsory Tasks',
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            Expanded(
              child: Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  var compulsoryTasks = taskProvider.compulsoryTasks;
                  return ListView.builder(
                    itemCount: compulsoryTasks.length,
                    itemBuilder: (context, index) {
                      Task task = compulsoryTasks[index];
                      return ListTile(
                        title: Text(
                            '${task.taskName}, ID: ${task.id}, Type: ${task.taskType.toString().split('.').last}, Freq: ${task.taskFrequency.toString().split('.').last}'),
                        subtitle: Text(task.taskDescription),
                        trailing: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => taskProvider.assignTask(
                              FirebaseAuth.instance.currentUser!.uid, task.id),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Scheduled Tasks',
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            Expanded(
              child: Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  var scheduledTasks = taskProvider.scheduledTasks;
                  return ListView.builder(
                    itemCount: scheduledTasks.length,
                    itemBuilder: (context, index) {
                      Task task = scheduledTasks[index];
                      return ListTile(
                        title: Text(
                            '${task.taskName}, ID: ${task.id}, Type: ${task.taskType.toString().split('.').last}, Freq: ${task.taskFrequency.toString().split('.').last}'),
                        subtitle: Text(task.taskDescription),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => taskProvider.removeTask(
                              FirebaseAuth.instance.currentUser!.uid, task.id),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Unassigned Tasks',
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            Expanded(
              child: Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  var unassignedTasks = taskProvider.unassignedTasks;
                  return ListView.builder(
                    itemCount: unassignedTasks.length,
                    itemBuilder: (context, index) {
                      Task task = unassignedTasks[index];
                      return ListTile(
                        title: Text(
                            '${task.taskName}, ID: ${task.id}, Type: ${task.taskType.toString().split('.').last}, Freq: ${task.taskFrequency.toString().split('.').last}'),
                        subtitle: Text(task.taskDescription),
                        trailing: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => taskProvider.assignTask(
                              FirebaseAuth.instance.currentUser!.uid, task.id),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('My Tasks',
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            Expanded(
              child: Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  var assignedTasks = taskProvider.assignedTasks;
                  return ListView.builder(
                    itemCount: assignedTasks.length,
                    itemBuilder: (context, index) {
                      Task task = assignedTasks[index];
                      return ListTile(
                        title: Text(
                            '${task.taskName}, ID: ${task.id}, Type: ${task.taskType.toString().split('.').last}, Frequency: ${task.taskFrequency.toString().split('.').last}, day_of_week: ${task.day_of_week.toString()}, day_of_month: ${task.day_of_month.toString()}'),
                        subtitle: Text(task.taskDescription),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => taskProvider.removeTask(
                              FirebaseAuth.instance.currentUser!.uid, task.id),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
