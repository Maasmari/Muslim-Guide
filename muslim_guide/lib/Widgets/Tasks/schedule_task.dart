import 'package:flutter/material.dart';
import 'package:muslim_guide/models/task.dart';
import 'package:muslim_guide/Widgets/Tasks/tasks.dart';

TaskFrequency taskF = TaskFrequency.once;

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

  void _presentDatePicker() async {
    final now = DateTime.now();
    DateTime firstDate = DateTime(
        DateTime.now().year - 1, DateTime.now().month, DateTime.now().day);
    DateTime lastDate = DateTime(
        DateTime.now().year + 1, DateTime.now().month, DateTime.now().day);
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
    final pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
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
          DropdownButton<TaskFrequency>(
          value: taskF,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (TaskFrequency? value) {
        // This is called when the user selects an item.
         setState(() {
          taskF = value!;
          });
         },
          items: TaskFrequency.values.map((TaskFrequency TF) {
              return DropdownMenuItem<TaskFrequency>(
                value: TF,
                child: Text(TF.toString()));
          },
          ).toList()),
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
                  if(_selectedDate != null && _selectedTime != null) {
                    task.date = _selectedDate!;
                    task.time = _selectedTime!;
                    task.taskFrequency = taskF;
                    var NoConflict = true;
                    for(int i=0;i<registeredTasks.length;i++){
                      if(registeredTasks[i].time == task.time && registeredTasks[i].date == task.date) {
                        showFlashError(context, 'Another task with the same Time and Date exists.');
                        NoConflict = false;
                        break;
                      }
                    }
                    if (NoConflict) {
                    registeredTasks.add(task);
                    showFlashError(context, 'Task has been added successfully');
                    }
                  }
                  else {
                    showFlashError(context, 'Please enter both date and time to add the task to your schedule.');
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
