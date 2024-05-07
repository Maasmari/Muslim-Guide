import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> createTaskCompletion(
    String userID, String taskID, DateTime date) async {
  Uri apiUrl = Uri.parse(
      'https://us-central1-muslim-guide-417618.cloudfunctions.net/app/task_completion/complete_task'); // Change this URL to your server's address

  // Format the date to YYYY-MM-DD
  String formattedDate = date.toIso8601String().substring(0, 10);

  try {
    final response = await http.post(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userID': userID,
        'taskID': taskID,
        'completionDate': formattedDate,
      }),
    );

    if (response.statusCode == 200) {
      print('Task completion record created successfully.');
      // Optionally, handle the response data
    } else {
      print('Failed to create task completion record: ${response.body}');
    }
  } catch (e) {
    print('Error occurred while sending data: $e');
  }
}

Future<void> deleteTaskCompletion(
    String userID, String taskID, DateTime date) async {
  Uri apiUrl = Uri.parse(
      'https://us-central1-muslim-guide-417618.cloudfunctions.net/app/task_completion/delete_completion_date'); // Adjust this URL to match your server

  // Format the date to YYYY-MM-DD
  String formattedDate = date.toIso8601String().substring(0, 10);

  try {
    final response = await http.delete(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userID': userID,
        'taskID': taskID,
        'completionDate': formattedDate,
      }),
    );

    if (response.statusCode == 200) {
      print('Task completion record deleted successfully.');
      // Optionally, handle the response data
    } else {
      print('Failed to delete task completion record: ${response.body}');
    }
  } catch (e) {
    print('Error occurred while deleting task completion record: $e');
  }
}

Future<bool> checkTaskCompletion(
    String userID, String taskID, DateTime date) async {
  Uri apiUrl = Uri.parse(
      'https://us-central1-muslim-guide-417618.cloudfunctions.net/app/task_completion/check_completion_date'); // Adjust this URL to match your server

  // Format the date to YYYY-MM-DD
  String formattedDate = date.toIso8601String().substring(0, 10);

  try {
    final response = await http.get(
      apiUrl.replace(queryParameters: <String, String>{
        'userID': userID,
        'taskID': taskID,
        'specificDate': formattedDate,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // Parse the JSON response
      var responseData = jsonDecode(response.body);
      return responseData['isCompleted'] as bool;
    } else {
      print('Failed to check task completion: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Error occurred while checking task completion: $e');
    return false;
  }
}

//get the number of tasks completed in a day
Future<int> getCompletedTasksCount(String userID, DateTime date) async {
  Uri apiUrl = Uri.parse(
      'https://us-central1-muslim-guide-417618.cloudfunctions.net/app/task_completion/get_number_of_tasks_completed'); // Adjust this URL to match your server

  // Format the date to YYYY-MM-DD
  String formattedDate = date.toIso8601String().substring(0, 10);

  try {
    final response = await http.get(
      apiUrl.replace(queryParameters: <String, String>{
        'userID': userID,
        'specificDate': formattedDate,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // Parse the JSON response
      var responseData = jsonDecode(response.body);
      return responseData['tasksCompleted'] as int;
    } else {
      print('Failed to get completed tasks count: ${response.body}');
      return 0;
    }
  } catch (e) {
    print('Error occurred while getting completed tasks count: $e');
    return 0;
  }
}
