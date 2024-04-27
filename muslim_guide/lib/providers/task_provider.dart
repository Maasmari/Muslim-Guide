import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:muslim_guide/models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _unassignedTasks = [];
  List<Task> _assignedTasks = [];

  List<Task> get unassignedTasks => _unassignedTasks;
  List<Task> get assignedTasks => _assignedTasks;

  void setUnassignedTasks(List<dynamic> tasks) {
    List<Task> newTasks =
        tasks.map((taskJson) => Task.fromJson(taskJson)).toList();
    for (var newTask in newTasks) {
      if (!_unassignedTasks.any((task) => task.id == newTask.id)) {
        _unassignedTasks.add(newTask);
      }
    }
    notifyListeners();
  }

  void setAssignedTasks(List<dynamic> tasks) {
    List<Task> newTasks =
        tasks.map((taskJson) => Task.fromJson(taskJson)).toList();
    for (var newTask in newTasks) {
      if (!_assignedTasks.any((task) => task.id == newTask.id)) {
        _assignedTasks.add(newTask);
      }
    }
    notifyListeners();
  }

  Future<void> fetchUnassignedTasks(String userID) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://us-central1-muslim-guide-417618.cloudfunctions.net/app/get_tasks/all_tasks/$userID'),
      );

      if (response.statusCode == 200) {
        setUnassignedTasks(json.decode(response.body)['tasks']);
      } else {
        throw Exception('Failed to load unassigned tasks');
      }
    } catch (e) {
      print('Error fetching unassigned tasks: $e');
    }
  }

  Future<void> fetchAssignedTasks(String userID) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://us-central1-muslim-guide-417618.cloudfunctions.net/app/get_tasks/user_tasks/$userID'),
      );

      if (response.statusCode == 200) {
        setAssignedTasks(json.decode(response.body)['tasks']);
      } else {
        throw Exception('Failed to load assigned tasks');
      }
    } catch (e) {
      print('Error fetching assigned tasks: $e');
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
        var taskToMove = _unassignedTasks.firstWhere(
          (task) => task.id == taskID,
          //orElse: () => null,
        );
        _unassignedTasks.remove(taskToMove);
        _assignedTasks.add(taskToMove);
        notifyListeners();
        print('Task assigned successfully!');
      } else {
        final error = json.decode(response.body)['error'] ?? 'Unknown error';
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
        var taskToUnassign = _assignedTasks.firstWhere(
          (task) => task.id == taskID,
        );

        _assignedTasks.remove(taskToUnassign);
        _unassignedTasks.add(taskToUnassign);
        notifyListeners();
        print('Task unassigned successfully!');
      } else {
        final responseBody = json.decode(response.body);
        final error = responseBody['error'] ?? 'Unknown server-side error';
        print('Failed to unassign the task: $error');
        print('Server responded with status code: ${response.statusCode}');
        print('Response body: $responseBody');
      }
    } on FormatException catch (e) {
      print('The server responded with an unexpected format: $e');
    } catch (e) {
      print('Failed to unassign task: $e');
    }
  }
}
