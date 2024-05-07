import 'package:flutter/material.dart';
import 'package:muslim_guide/Widgets/chart.dart';
import 'package:intl/intl.dart';

final DateFormat formatterYMD = DateFormat.yMEd();

class PerformanceScreen extends StatefulWidget {
  @override
  _PerformanceScreenState createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  @override
  Widget build(BuildContext context) {
    String lastdate = formatterYMD.format(DateTime.now());
    String firstdate =
        formatterYMD.format(DateTime.now().subtract(const Duration(days: 6)));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Performance',
            style: TextStyle(color: Colors.white, fontSize: 23)),
        backgroundColor: const Color.fromARGB(255, 30, 87, 32),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text('Last 7 days ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text(firstdate + ' - ' + lastdate,
                style: TextStyle(fontSize: 11, color: Colors.grey)),
            Chart(),
          ],
        ),
      ),
    );
  }
}
