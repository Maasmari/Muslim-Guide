import 'package:intl/intl.dart';

final DateFormat formatterYMD = DateFormat.yMd();
final DateFormat formatterHour = DateFormat.jm(); // jm = hour minute

class CompletionRecord {
  late final String taskID;
  late final DateTime? date;

  CompletionRecord({
    required this.taskID,
    required this.date,
  });

  factory CompletionRecord.fromJson(Map<String, dynamic> json) {
    //make the date to be in the format of 2022-01-26
    DateTime date = DateTime.parse(json['completion_date']);
    DateTime formattedDate = DateTime(date.year, date.month, date.day);
    print(
        'taskID = ${json['task_instance_taskID'].toString()} + formattedDate: $formattedDate');
    return CompletionRecord(
        taskID: json['task_instance_taskID'].toString(), date: formattedDate);
  }
}
