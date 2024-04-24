import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Function to fetch unassigned tasks
Future<List<dynamic>> fetchUnassignedTasks(String userID) async {
  final response = await http.get(
    Uri.parse(
        'https://us-central1-muslim-guide-417618.cloudfunctions.net/app/get_tasks/all_tasks/$userID'),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body)['tasks'];
  } else {
    throw Exception('Failed to load unassigned tasks');
  }
}

// Function to fetch assigned tasks
Future<List<dynamic>> fetchAssignedTasks(String userID) async {
  final response = await http.get(
    Uri.parse(
        'https://us-central1-muslim-guide-417618.cloudfunctions.net/app/get_tasks/user_tasks/$userID'),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body)['tasks'];
  } else {
    throw Exception('Failed to load assigned tasks');
  }
}

// StatefulWidget to manage task screens
class TaskScreenDB extends StatefulWidget {
  @override
  _TaskScreenDBState createState() => _TaskScreenDBState();
}

class _TaskScreenDBState extends State<TaskScreenDB> {
  late Future<List<dynamic>> futureUnassignedTasks;
  late Future<List<dynamic>> futureAssignedTasks;

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
      setState(() {
        futureUnassignedTasks = fetchUnassignedTasks(userID);
        futureAssignedTasks = fetchAssignedTasks(userID);
      });
    } else {
      print('User not signed in');
    }
  }

  Future<void> assignTask(String userID, String taskID) async {
    if (userID.isEmpty || taskID.isEmpty) {
      print('Invalid userID or taskID');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
            'https://us-central1-muslim-guide-417618.cloudfunctions.net/app/assign_task'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'userID': userID,
          'taskID': taskID,
        }),
      );

      if (response.statusCode == 201) {
        print('Task assigned successfully!');
        initTasks(); // Refresh tasks after assignment
      } else {
        final error = json.decode(response.body)['error'];
        print('Failed to assign the task: $error');
      }
    } on FormatException catch (e) {
      print('The server responded with an unexpected format: $e');
    } catch (e) {
      print('Failed to assign task: $e');
    }
  }

  Future<void> removeTask(String userID, String taskID) async {
    if (userID.isEmpty || taskID.isEmpty) {
      print('Invalid userID or taskID');
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse(
            'https://us-central1-muslim-guide-417618.cloudfunctions.net/app/assign_task/remove_task'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'userID': userID,
          'taskID': taskID,
        }),
      );

      if (response.statusCode == 200) {
        print('Task removed successfully!');
        initTasks(); // Refresh tasks after removal
      } else {
        final error = json.decode(response.body)['error'];
        print('Failed to remove the task: $error');
      }
    } on FormatException catch (e) {
      print('The server responded with an unexpected format: $e');
    } catch (e) {
      print('Failed to remove task: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Unassigned Tasks',
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: futureUnassignedTasks,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }

                  return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      var task = snapshot.data![index];
                      return ListTile(
                        title: Text(task['taskName']),
                        subtitle: Text(task['taskDescription']),
                        trailing: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => assignTask(
                              FirebaseAuth.instance.currentUser!.uid,
                              task['taskID'].toString()),
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
              child: FutureBuilder<List<dynamic>>(
                future: futureAssignedTasks,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    //return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }

                  return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      var task = snapshot.data![index];
                      return ListTile(
                        title: Text(task['taskName']),
                        subtitle: Text(task['taskDescription']),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => removeTask(
                              FirebaseAuth.instance.currentUser!.uid,
                              task['taskID'].toString()),
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
