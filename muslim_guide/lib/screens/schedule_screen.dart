import 'package:flutter/material.dart';
import 'package:muslim_guide/Widgets/Tasks/tasks.dart';
import 'package:muslim_guide/Widgets/Tasks/tasks_list.dart';
import 'package:muslim_guide/screens/task_list_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:muslim_guide/models/task.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() {
    return _ScheduleState();
  }
}

class _ScheduleState extends State<ScheduleScreen> {

  DateTime today = DateTime.now();
  DateTime firstDate = DateTime(
      DateTime.now().year - 1, DateTime.now().month, DateTime.now().day);
  DateTime lastDate = DateTime(
      DateTime.now().year + 1, DateTime.now().month, DateTime.now().day);

  Map<DateTime, List<Task>> tasks = {};
  late final ValueNotifier<List<Task>> _selectedTasks;

  @override
  void initState(){
    super.initState();
    _selectedTasks = ValueNotifier(_getTasksForDay(today));
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
      print(day);
    });
  }

  List<Task> _getTasksForDay(DateTime day) {
    List<Task> TasksOfTheDay = [];
    for(int i=0;i<registeredTasks.length;i++){
      if(day.year == registeredTasks[i].date.year && day.month == registeredTasks[i].date.month && day.day == registeredTasks[i].date.day) {
        TasksOfTheDay.add(registeredTasks[i]);
      }
    }
     return TasksOfTheDay;
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
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const TaskListScreen()));
              } /* change active screen to TaskListScreen() */,
              icon: const Icon(Icons.add, color: Colors.white))
        ],
      ),
      body: content(),
    );
  }

  Widget content() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        //might need to be adjust to add itemBuilder (Vid 101)
        children: [
          TableCalendar(
            focusedDay: today,
            firstDay: firstDate,
            lastDay: lastDate,
            locale: 'en_US',
            headerStyle: const HeaderStyle(
              formatButtonVisible: false, titleCentered: true),
            availableGestures: AvailableGestures.all,
            onDaySelected: _onDaySelected,
            selectedDayPredicate: (day) => isSameDay(day, today),
            eventLoader: _getTasksForDay,
          ),
          const Divider(
            color: Colors.black,
            thickness: 2,
          ),
          Expanded(
            child: ValueListenableBuilder<List<Task>>(valueListenable: _selectedTasks, builder: (context, value, _) {
              return TasksList(tasks: _getTasksForDay(today));
            },
            ),
          ),
          //const Tasks(),
        ],
      ),
    );
  }
}
