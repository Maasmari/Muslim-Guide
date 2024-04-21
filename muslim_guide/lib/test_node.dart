import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchTasks(String userID) async {
  final response = await http.get(
    Uri.parse(
        'https://us-central1-muslim-guide-417618.cloudfunctions.net/app/get_tasks/tasks/$userID'),
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    return json.decode(response.body)['tasks'];
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load tasks');
  }
}

class TaskScreenDB extends StatefulWidget {
  @override
  _TaskScreenDBState createState() => _TaskScreenDBState();
}

class _TaskScreenDBState extends State<TaskScreenDB> {
  late Future<List<dynamic>> futureTasks;

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
        futureTasks = fetchTasks(userID);
      });
    } else {
      // Handle user not being signed in
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
      ),
      body: Center(
        child: FutureBuilder<List<dynamic>>(
          future: futureTasks,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
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
                );
              },
            );
          },
        ),
      ),
    );
  }
}
