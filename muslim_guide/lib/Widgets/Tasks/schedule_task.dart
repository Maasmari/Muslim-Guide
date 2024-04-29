import 'package:flutter/material.dart';
import 'package:muslim_guide/models/task.dart';
import 'package:muslim_guide/providers/task_provider.dart';
import 'package:provider/provider.dart';

class ScheduleTask extends StatefulWidget {
  const ScheduleTask({super.key, required this.task});

  final Task task;

  @override
  State<ScheduleTask> createState() {
    // ignore: no_logic_in_create_state
    return _ScheduleTaskState(task: task);
  }
}

class _ScheduleTaskState extends State<ScheduleTask> {
  _ScheduleTaskState({required this.task});
  final Task task;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  TaskFrequency? taskF;

  DateTime CheckFrequency(TaskFrequency freq) {
//if daily,weekly,monthly.......
    if (taskF == TaskFrequency.daily) {
      return DateTime.now();
    } else if (taskF == TaskFrequency.weekly) {
      return DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day + 7);
    } else if (taskF == TaskFrequency.monthly) {
      return DateTime(
          DateTime.now().year, DateTime.now().month + 1, DateTime.now().day);
    } else
      return DateTime(
          DateTime.now().year + 1, DateTime.now().month, DateTime.now().day);
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    DateTime firstDate = now;
    DateTime lastDate = CheckFrequency(taskF!);
    final pickedDate = await showDatePicker(
        context: context,
        firstDate: firstDate,
        lastDate: lastDate,
        initialDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _presentTimePicker() async {
    final pickedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    setState(() {
      _selectedTime = pickedTime;
    });
  }

  void showFlashError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Task> registeredTasks =
        Provider.of<TaskProvider>(context, listen: true).assignedTasks;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          DropdownButton<TaskFrequency>(
              value: taskF,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              underline: Container(
                height: 2,
                color: Color.fromARGB(255, 14, 85, 0),
              ),
              onChanged: (TaskFrequency? value) {
                // This is called when the user selects an item.
                setState(() {
                  taskF = value!;
                });
              },
              items: TaskFrequency.values.map(
                (TaskFrequency TF) {
                  return DropdownMenuItem<TaskFrequency>(
                      value: TF, child: Text(TF.name));
                },
              ).toList()),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _selectedTime == null
                    ? 'No time selected'
                    : _selectedTime!.format(context),
              ),
              IconButton.filled(
                onPressed: _presentTimePicker,
                icon: const Icon(
                  Icons.access_time,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _selectedDate == null
                    ? 'No date selected'
                    : formatterYMD.format(_selectedDate!),
              ),
              IconButton.filled(
                onPressed: _presentDatePicker,
                icon: const Icon(
                  Icons.calendar_month,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_selectedDate != null && _selectedTime != null) {
                    task.date = _selectedDate!;
                    task.time = _selectedTime!;
                    task.taskFrequency = taskF!;
                    var NoConflict = true;

                    if (taskF == TaskFrequency.daily &&
                            _selectedDate!.day != DateTime.now().day ||
                        _selectedDate!.month != DateTime.now().month) {
                      showFlashError(
                          context, 'Incorrect date, please select again.');
                      NoConflict = false;
                    } else if (taskF == TaskFrequency.weekly &&
                        _selectedDate!.difference(DateTime.now()).inDays > 7) {
                      showFlashError(
                          context, 'Incorrect date, please select again.');
                      NoConflict = false;
                    } else if (taskF == TaskFrequency.monthly) {
                      if (_selectedDate!.month == 1 ||
                          _selectedDate!.month == 3 ||
                          _selectedDate!.month == 5 ||
                          _selectedDate!.month == 7 ||
                          _selectedDate!.month == 8 ||
                          _selectedDate!.month == 10 ||
                          _selectedDate!.month == 12 &&
                              _selectedDate!.difference(DateTime.now()).inDays >
                                  31) {
                        showFlashError(
                            context, 'Incorrect date, please select again.');
                        NoConflict = false;
                      } else if (_selectedDate!.month == 4 ||
                          _selectedDate!.month == 6 ||
                          _selectedDate!.month == 9 ||
                          _selectedDate!.month == 11 &&
                              _selectedDate!.difference(DateTime.now()).inDays >
                                  30) {
                        showFlashError(
                            context, 'Incorrect date, please select again.');
                        NoConflict = false;
                      } else {
                        if (_selectedDate!.year % 4 == 0 &&
                            _selectedDate!.difference(DateTime.now()).inDays >
                                29) {
                          //maybe needs adjustment, need to test
                          showFlashError(
                              context, 'Incorrect date, please select again.');
                          NoConflict = false;
                        } else if (_selectedDate!.year % 4 != 0 &&
                            _selectedDate!.difference(DateTime.now()).inDays >
                                28) {
                          showFlashError(
                              context, 'Incorrect date, please select again.');
                          NoConflict = false;
                        }
                      }
                    }

                    for (int i = 0; i < registeredTasks.length; i++) {
                      if (registeredTasks[i].time == task.time &&
                          registeredTasks[i].date == task.date) {
                        showFlashError(context,
                            'Another task with the same Time and Date exists.');
                        NoConflict = false;
                        break;
                      }
                    }
                    if (NoConflict) {
                      registeredTasks.add(task);
                      showFlashError(
                          context, 'Task has been added successfully');
                    }
                  } else {
                    showFlashError(context,
                        'Please enter valid date and time to add the task to your schedule.');
                  }
                  Navigator.pop(context);
                },
                child: const Text('Add to schedule'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
