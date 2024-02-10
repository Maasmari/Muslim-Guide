import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatterYMD = DateFormat.yMd();
final formatterHour = DateFormat.jm(); //jm = hour minute

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
    //required this.date //maybe? then adjust it when user adds it
    //required this.time
  })  : id = uuid.v4(),
        date = DateTime.now(),
        time = DateTime.now();
  

  final String id;
  final String taskName;
  String taskDescription;
  TaskType taskType;
  TaskFrequency taskFrequency;
  DateTime date;
  DateTime time;
  bool isCompleted;

  String get formattedDate {
    return formatterYMD.format(date);
  }
  String get formattedTime {
      return formatterHour.format(time);
  }

}
