import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:muslim_guide/models/task.dart';
import 'package:muslim_guide/providers/task_provider.dart';
import 'package:provider/provider.dart';

final DateFormat formatterYMD =
    DateFormat('yyyy-MM-dd'); // Ensure this formatter is declared

class ScheduleTask extends StatefulWidget {
  const ScheduleTask({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  State<ScheduleTask> createState() => _ScheduleTaskState();
}

class _ScheduleTaskState extends State<ScheduleTask> {
  TimeOfDay? _selectedTime;
  TaskFrequency? _taskFrequency = TaskFrequency.daily;
  int? _selectedDayOfWeek;
  int? _selectedDayOfMonth;
  int? _selectedMonth;
  int? _selectedYear;
  DateTime? _selectedDate;

  final Map<int, String> _weekDaysMap = {
    1: 'Sunday',
    2: 'Monday',
    3: 'Tuesday',
    4: 'Wednesday',
    5: 'Thursday',
    6: 'Friday',
    7: 'Saturday'
  };

  void _presentTimePicker() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  Widget _buildDayOfWeekSelector() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _weekDaysMap.length,
      itemBuilder: (context, index) {
        return ChoiceChip(
          label: Text(_weekDaysMap[index + 1]!),
          selected: _selectedDayOfWeek == index,
          onSelected: (bool selected) {
            setState(() {
              _selectedDayOfWeek = selected ? index : null;
            });
          },
        );
      },
    );
  }

  Widget _buildDayOfMonthSelector() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7, // This sets up a week's view
        childAspectRatio: 2 / 1, // Adjust aspect ratio for better spacing
      ),
      itemCount: 31, // Represents days of the month, assuming the maximum
      itemBuilder: (context, index) {
        bool isSelected = _selectedDayOfMonth == index + 1;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDayOfMonth = index + 1;
            });
          },
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(
                2), // Adding margin for spacing between elements
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context)
                      .colorScheme
                      .secondary // Selected color based on theme
                  : Theme.of(context).cardColor, // Default color based on theme
              borderRadius: BorderRadius.circular(
                  4), // Rounded corners for a smoother look
              border: Border.all(
                color: isSelected
                    ? Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer // Highlighting the border when selected
                    : Colors
                        .transparent, // Transparent border for unselected items
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: isSelected
                    ? Colors.white // White text for selected day
                    : Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .color, // Default text color based on theme
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildYearlySelector() {
    return Column(
      children: [
        ListTile(
          title: Text(_selectedDate == null
              ? 'Select Date'
              : 'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}'),
          trailing: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _presentDatePicker,
          ),
        ),
      ],
    );
  }

  Widget _buildOnceSelector() {
    return Column(
      children: [
        ListTile(
          title: Text(_selectedDate == null
              ? 'Select Date'
              : 'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}'),
          trailing: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _onceDatePicker,
          ),
        ),
      ],
    );
  }

  void _presentDatePicker() async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = DateTime(now.year);
    final DateTime lastDate = DateTime(now.year + 1);
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _selectedDayOfMonth = pickedDate.day;
        _selectedMonth = pickedDate.month;
      });
    }
  }

  void _onceDatePicker() async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = DateTime(now.year);
    final DateTime lastDate = DateTime(now.year + 100);
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _selectedDayOfMonth = pickedDate.day;
        _selectedMonth = pickedDate.month;
        _selectedYear = pickedDate.year;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> scheduleTask() async {
      // Logic to save the task based on selected parameters
      // You can access the selected parameters such as _taskFrequency,
      // _selectedTime, _selectedDayOfWeek, _selectedDayOfMonth, and _selectedDate
      // and perform the scheduling accordingly.

      //make the task's time, day of week, day of month, month of year null first
      //then assign the selected values to them

      // For example, you can print the selected parameters for demonstration:
      String freq = _taskFrequency.toString().split('.').last;
      //display time as 13:00:00 add 12 if it is PM
      String? time = _selectedTime != null
          ? '${_selectedTime!.hour}:${_selectedTime!.minute}:00'
          : null;
      int? dayOfWeek =
          _selectedDayOfWeek != null ? _selectedDayOfWeek! + 1 : null;
      int? dayOfMonth = _selectedDayOfMonth;
      int? monthOfYear = _selectedMonth;
      int? year = _selectedYear;
      String taskID = widget.task.id;
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = await auth.currentUser;
      String userID = '';
      if (user != null) {
        userID = user.uid;
      }

      print('Frequency: $freq');
      print('Time: $time');
      print('Day of Week: $dayOfWeek');
      print('Day of Month: $dayOfMonth');
      print('Month: $monthOfYear');
      print('Task id: $taskID');
      print('user id: $userID');

      TaskProvider taskProvider =
          Provider.of<TaskProvider>(context, listen: false);
      taskProvider.assignTask(userID, taskID);

      //wait for the task to be assigned
      await Future.delayed(Duration(seconds: 1));

      taskProvider.createSchedule(
        freq,
        time,
        dayOfWeek,
        dayOfMonth,
        monthOfYear,
        year,
        taskID,
        userID,
      );
    }

    return Scaffold(
      appBar: AppBar(
          title: Text('Schedule Task', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 30, 87, 32)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            DropdownButton<TaskFrequency>(
              value: _taskFrequency,
              onChanged: (TaskFrequency? newValue) {
                setState(() {
                  _taskFrequency = newValue;
                  _selectedDate = null;
                  _selectedDayOfMonth = null;
                  _selectedDayOfWeek = null;
                  _selectedTime = null;
                  _selectedMonth = null;
                  _selectedYear = null;
                });
              },
              items: TaskFrequency.values.map((TaskFrequency frequency) {
                return DropdownMenuItem<TaskFrequency>(
                  value: frequency,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context)
                          .canvasColor, // Respect theme color for light/dark mode compatibility
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _getFrequencyIcon(
                              frequency), // Get an icon based on the frequency
                          color: Theme.of(context)
                              .iconTheme
                              .color, // Use theme's icon color
                        ),
                        const SizedBox(width: 10),
                        Text(
                          frequency.toString().split('.').last,
                          style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .color, // Text color from theme
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            if (_taskFrequency != null) ...[
              ListTile(
                title: Text(_selectedTime == null
                    ? 'Select Time'
                    : 'Time: ${_selectedTime!.format(context)}'),
                trailing: IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: _presentTimePicker,
                ),
              ),
              if (_taskFrequency == TaskFrequency.weekly)
                Container(
                  height: 56,
                  child: _buildDayOfWeekSelector(),
                ),
              if (_taskFrequency == TaskFrequency.monthly)
                Container(
                  height: 200,
                  child: _buildDayOfMonthSelector(),
                ),
              if (_taskFrequency == TaskFrequency.yearly)
                Container(height: 100, child: _buildYearlySelector()),
              if (_taskFrequency == TaskFrequency.once)
                Container(height: 100, child: _buildOnceSelector()),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 30, 87, 32),
              ),
              onPressed: () {
                // if the time is not selected show a snackbar
                if (_selectedTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: const Color.fromARGB(255, 196, 48, 38),
                      content: Text('Please select a time!'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  return;
                }
                scheduleTask();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('Task added!'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Text('Save Task', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}

IconData? _getFrequencyIcon(TaskFrequency frequency) {
  switch (frequency) {
    case TaskFrequency.daily:
      return Icons.calendar_today; // Example icon for daily tasks
    case TaskFrequency.weekly:
      return Icons.calendar_view_week; // Example icon for weekly tasks
    case TaskFrequency.monthly:
      return Icons.calendar_view_month; // Example icon for monthly tasks
    case TaskFrequency.yearly:
      return Icons.date_range; // Example icon for yearly tasks
    default:
      return Icons.event; // Default icon for unspecified frequencies
  }
}
