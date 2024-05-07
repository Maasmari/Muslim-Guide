import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:muslim_guide/models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _unassignedTasks =
      []; // this is the list used outside the class to get all the unassigned tasks
  List<Task> _assignedTasks =
      []; // this is the list used outside the class to all get the assigned tasks

  List<Task> _compulsoryTasks = [];
  List<Task> _scheduledTasks = [];
  List<Task> _assignedOptionalTasks = [];

  List<Task> get unassignedTasks => _unassignedTasks;
  List<Task> get assignedTasks => _assignedTasks;

  List<Task> get assignedOptionalTasks => _assignedOptionalTasks;
  List<Task> get compulsoryTasks => _compulsoryTasks;
  List<Task> get scheduledTasks => _scheduledTasks;

  Future<void> setAssignedTasks(String userID) async {
    await fetchCompulsoryTasks();
    _assignedTasks = _compulsoryTasks;
    notifyListeners();
    await fetchScheduledTasks(userID);
    await fetchAssignedOptionalTasks(userID);

    _assignedTasks =
        _compulsoryTasks + _scheduledTasks + _assignedOptionalTasks;

    _assignedTasks.sort((a, b) {
      // Convert hours and minutes to total minutes from midnight
      int minutesA = a.time.hour * 60 + a.time.minute;
      int minutesB = b.time.hour * 60 + b.time.minute;

      // Compare the total minutes to sort the tasks
      return minutesA.compareTo(minutesB);
    });

    notifyListeners();
  }

  Future<void> fetchCompulsoryTasks() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://us-central1-muslim-guide-417618.cloudfunctions.net/app/get_tasks/compulsory_tasks'),
      );

      if (response.statusCode == 200) {
        _compulsoryTasks =
            json.decode(response.body)['tasks'].map<Task>((taskJson) {
          return Task.fromJson(taskJson);
        }).toList();
        print('Compulsory tasks fetched successfully!');
        notifyListeners();
      } else {
        throw Exception('Failed to load compulsory tasks');
      }
    } catch (e) {
      print('Error fetching compulsory tasks: $e');
    }
  }

  Future<void> fetchScheduledTasks(String userID) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://us-central1-muslim-guide-417618.cloudfunctions.net/app/get_tasks/scheduled_tasks/$userID'),
      );

      if (response.statusCode == 200) {
        _scheduledTasks =
            json.decode(response.body)['tasks'].map<Task>((taskJson) {
          return Task.fromJson(taskJson);
        }).toList();
        print('Scheduled tasks fetched successfully!');
        notifyListeners();
      } else {
        throw Exception('Failed to load scheduled tasks');
      }
    } catch (e) {
      print('Error fetching scheduled tasks: $e');
    }
  }

  void setUnassignedTasks(List<dynamic> tasks) {
    _unassignedTasks =
        tasks.map((taskJson) => Task.fromJson(taskJson)).toList();
    notifyListeners();
  }

  void setAssignedOptionalTasks(List<dynamic> tasks) {
    _assignedOptionalTasks =
        tasks.map((taskJson) => Task.fromJson(taskJson)).toList();
    notifyListeners();
  }

  //lets use it to assign a non adjustable and non adjustable task to a user
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
      print(response.statusCode);
      if (response.statusCode == 201) {
        // Collect all tasks that match the condition
        var tasksToMove =
            _unassignedTasks.where((task) => task.id == taskID).toList();

        // Remove all found tasks from _unassignedTasks
        _unassignedTasks.removeWhere((task) => task.id == taskID);

        // Add all found tasks to _assignedTasks
        _assignedTasks.addAll(tasksToMove);

        notifyListeners();
        print('Tasks assigned successfully!');
      } else {
        final error = json.decode(response.body)['message'];
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
        // Collect all tasks that match the condition
        var tasksToUnassign =
            _assignedTasks.where((task) => task.id == taskID).toList();

        // Remove all found tasks from _assignedTasks
        _assignedTasks.removeWhere((task) => task.id == taskID);

        // Add all found tasks to _unassignedTasks
        _unassignedTasks.addAll(tasksToUnassign);

        notifyListeners();
        print('Tasks unassigned successfully!');
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

  Future<void> createSchedule(
      String freq,
      String? time_of_day,
      int? day_of_week,
      int? day_of_month,
      int? month_of_year,
      int? year,
      String taskID,
      String userID) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://us-central1-muslim-guide-417618.cloudfunctions.net/app/schedule/create'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'scheduleType': freq,
          'timeOfDay': time_of_day,
          'dayOfWeek': day_of_week,
          'dayOfMonth': day_of_month,
          'monthOfYear': month_of_year,
          'year': year,
          'taskID': taskID,
          'userID': userID,
        }),
      );

      if (response.statusCode == 201) {
        setAssignedTasks(userID);
        notifyListeners();
        print('Schedule created successfully!');
      } else {
        final responseBody = json.decode(response.body);
        final error = responseBody['error'] ?? 'Unknown server-side error';
        print('Failed to create the schedule: $error');
        print('Server responded with status code: ${response.statusCode}');
        print('Response body: $responseBody');
      }
    } on FormatException catch (e) {
      print('The server responded with an unexpected format: $e');
    } catch (e) {
      print('Failed to create schedule: $e');
    }
  }

  Future<void> fetchUnassignedTasks(String userID) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://us-central1-muslim-guide-417618.cloudfunctions.net/app/get_tasks/all_tasks/$userID'),
      );

      if (response.statusCode == 200) {
        setUnassignedTasks(json.decode(response.body)['tasks']);
        notifyListeners();
      } else {
        throw Exception('Failed to load unassigned tasks');
      }
    } catch (e) {
      print('Error fetching unassigned tasks: $e');
    }
  }

  Future<void> fetchAssignedOptionalTasks(String userID) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://us-central1-muslim-guide-417618.cloudfunctions.net/app/get_tasks/user_tasks/$userID'),
      );

      if (response.statusCode == 200) {
        setAssignedOptionalTasks(json.decode(response.body)['tasks']);
        notifyListeners();
      } else {
        throw Exception('Failed to load assigned tasks');
      }
    } catch (e) {
      print('Error fetching assigned tasks: $e');
    }
  }

  Future<void> assignAllCompulsoryTasks(String userID) async {
    if (userID.isEmpty) {
      print('Invalid userID');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
            'https://us-central1-muslim-guide-417618.cloudfunctions.net/app/assign_task/assign_all_compulsory_tasks_to_user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'userID': userID,
        }),
      );

      if (response.statusCode == 201) {
        notifyListeners();
        print('All compulsory tasks assigned successfully!');
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
}
