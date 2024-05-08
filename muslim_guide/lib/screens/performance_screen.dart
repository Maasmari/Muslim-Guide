import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:muslim_guide/Widgets/chart.dart';

final DateFormat formatterYMD = DateFormat.yMEd();

class PerformanceScreen extends StatefulWidget {
  @override
  _PerformanceScreenState createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  late DateTime _startDate;

  @override
  void initState() {
    super.initState();
    _calculateStartDate();
  }

  void _calculateStartDate() {
    // Get the current date
    DateTime currentDate = DateTime.now();
    // Calculate the difference between the current date's weekday and Sunday (7)
    int daysUntilSunday = 7 - currentDate.weekday;
    // Adjust the start date to the nearest Sunday
    _startDate = currentDate.add(Duration(days: daysUntilSunday));
  }

  void _navigateToPreviousWeek() {
    setState(() {
      _startDate = _startDate.subtract(Duration(days: 7));
    });
  }

  void _navigateToNextWeek() {
    setState(() {
      _startDate = _startDate.add(Duration(days: 7));
    });
  }

  String _getWeekText() {
    DateTime endDate = _startDate.add(Duration(days: 6));
    final String firstdate = formatterYMD.format(_startDate);
    final String lastdate = formatterYMD.format(endDate);
    return '$firstdate - $lastdate';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Performance',
          style: TextStyle(color: Colors.white, fontSize: 23),
        ),
        backgroundColor: const Color.fromARGB(255, 30, 87, 32),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_left),
                  onPressed: _navigateToPreviousWeek,
                ),
                Text(
                  _getWeekText(), // Updated to dynamically display week text
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_right),
                  onPressed: _navigateToNextWeek,
                ),
              ],
            ),
            SizedBox(height: 20),
            Chart(startDate: _startDate),
          ],
        ),
      ),
    );
  }
}
