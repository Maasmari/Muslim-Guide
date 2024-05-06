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
  int isAdjustable;
  int day_of_week;
  int day_of_month;
  int month_of_year;
  int year;

  Task({
    required this.id,
    required this.taskName,
    required this.taskDescription,
    required this.taskType, // optional or compulsory
    required this.taskFrequency, // daily, weekly, monthly, yearly, once
    required this.isCompleted,
    required this.isAdjustable,
    required this.date,
    required this.time,
    required this.day_of_week, // 1 = Sunday, 1 = Monday, ..., 7 = Saturday
    required this.day_of_month, // 1-31
    required this.month_of_year, // 1-12
    required this.year,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['taskID'].toString(), // Convert taskID to string.
      taskName: json['taskName'] ?? 'Default Name',
      taskDescription: json['taskDescription'] ?? 'No description provided',
      taskType: json['taskType'] == 'compulsory'
          ? TaskType.compulsory
          : TaskType.optional,
      taskFrequency: TaskFrequency.values.firstWhere(
          (f) =>
              f.toString().split('.').last == (json['schedule_type'] ?? 'once'),
          orElse: () => TaskFrequency.once),
      isCompleted: json['isCompleted'] ?? false,
      isAdjustable: json['isAdjustable'] ?? false,
      date: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : DateTime.now(),
      time: json['time_of_day'] != null
          ? _parseTimeOfDay(json['time_of_day'])
          : TimeOfDay(hour: 0, minute: 0),
      day_of_week: json['day_of_week'] ?? 0,
      day_of_month: json['day_of_month'] ?? 0,
      month_of_year: json['month_of_year'] ?? 0,
      year: json['year_of_schedule'] ?? 0,
    );
  }

  static TimeOfDay _parseTimeOfDay(String time) {
    final timeParts = time.split(':');
    return TimeOfDay(
        hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
  }
}
