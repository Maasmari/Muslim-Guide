import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum TaskType { optional, compulsory }

enum TaskFrequency { daily, weekly, monthly, yearly, other, once }

class Task {
  Task({
    required this.taskName,
    required this.taskDescription,
    required this.taskType,
    required this.taskFrequency,
    required this.isCompleted,
  }) : id = uuid.v4();

  final String id;
  final String taskName;
  String taskDescription;
  TaskType taskType;
  TaskFrequency taskFrequency;
  bool isCompleted;
}
