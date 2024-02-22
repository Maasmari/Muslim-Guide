import 'package:flutter/material.dart';
import 'package:muslim_guide/Widgets/chart.dart';

class PerformanceScreen extends StatefulWidget {
  @override
  _PerformanceScreenState createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  @override
  Widget build(BuildContext context) {
    int weekNumber = 1;
    String date = '2021/09/01  -  2021/09/07';

    return Scaffold(
      appBar: AppBar(
        title: Text('Performance', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 30, 87, 32),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              //make in the center
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back_ios),
                SizedBox(width: 20),
                Text('Week $weekNumber',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(width: 20),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
            SizedBox(height: 20),
            Text(date, style: TextStyle(fontSize: 11, color: Colors.grey)),
            Chart(),
          ],
        ),
      ),
    );
  }
}
