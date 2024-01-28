import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() {
    return _ScheduleState();
  }
}

class _ScheduleState extends State<ScheduleScreen> {
  bool isCompleted = false;

  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Schedule',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 30, 87, 32),
      ),
      body: content(),
    );
  }

  Widget content() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          TableCalendar(
            focusedDay: today,
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2099, 12, 31),
            locale: 'en_US',
            headerStyle: const HeaderStyle(
                formatButtonVisible: false, titleCentered: true),
            availableGestures: AvailableGestures.all,
            onDaySelected: _onDaySelected,
            selectedDayPredicate: (day) => isSameDay(day, today),
          ),
          const Divider(
            color: Colors.black,
            thickness: 2,
          ),
          Row(
            children: [
              const Text('Task name here'),
              const Spacer(),
              Checkbox(
                activeColor: Colors.green,
                value: isCompleted,
                onChanged: (value) {
                  setState(
                    () {
                      isCompleted = value!;
                    },
                  );
                },
              ),
              const SizedBox(
                width: 5,
              ),
              const Text('Ex: 5:40 PM'),
            ],
          ),
          const SizedBox(
            height: 6,
          ),
          const Divider(
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
