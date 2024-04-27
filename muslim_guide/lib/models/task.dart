import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final DateFormat formatterYMD = DateFormat.yMd();
final DateFormat formatterHour = DateFormat.jm(); // jm = hour minute

enum TaskType { optional, compulsory }

enum TaskFrequency { daily, weekly, monthly, yearly, once }

class Task {
  final String id;
  final String taskName;
  String taskDescription;
  TaskType taskType;
  TaskFrequency taskFrequency;
  DateTime date;
  TimeOfDay time;
  bool isCompleted;

  Task({
    required this.id, // ID is now a required parameter.
    required this.taskName,
    required this.taskDescription,
    required this.taskType,
    required this.taskFrequency,
    required this.isCompleted,
    required this.date,
    required this.time,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['taskID'].toString(), // Convert taskID to string.
      taskName: json['taskName'] ?? 'Default Name',
      taskDescription: json['taskDescription'] ?? 'No description provided',
      taskType: json['taskType'] == 'mandatory'
          ? TaskType.compulsory
          : TaskType.optional,
      taskFrequency: TaskFrequency.values.firstWhere(
          (f) =>
              f.toString().split('.').last == (json['schedule_type'] ?? 'once'),
          orElse: () => TaskFrequency.once),
      isCompleted: json['isCompleted'] ?? false,
      date: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : DateTime.now(),
      time: json['time_of_day'] != null
          ? _parseTimeOfDay(json['time_of_day'])
          : TimeOfDay(hour: 0, minute: 0),
    );
  }

  static TimeOfDay _parseTimeOfDay(String time) {
    final timeParts = time.split(':');
    return TimeOfDay(
        hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
  }
}
