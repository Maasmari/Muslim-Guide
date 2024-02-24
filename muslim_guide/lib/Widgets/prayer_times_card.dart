import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';

// Define a model for prayer times to pass to the widget
class LocalPrayerTimes {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  LocalPrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });
}

String formatCombinedDate() {
  // Create a HijriCalendar instance for the current date
  final HijriCalendar hijriDate = HijriCalendar.now();

  // Create a DateTime instance for the current date
  final DateTime gregorianDate = DateTime.now();

  // List of week days
  final List<String> weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  // List of Gregorian months
  final List<String> gregorianMonths = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  // Formatting the output
  String formattedDate = '${weekDays[gregorianDate.weekday - 1]} '
      '${hijriDate.hDay} ${hijriDate.longMonthName} | '
      '${gregorianMonths[gregorianDate.month - 1]} ${gregorianDate.day}';

  return formattedDate;
}

class PrayerTimeCard extends StatelessWidget {
  final LocalPrayerTimes prayerTimes;
  final String city;

  PrayerTimeCard({required this.prayerTimes, required this.city});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(
            255, 39, 45, 213), // Adjust the color to match your design
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Text(
            formatCombinedDate(), // Replace with dynamic date
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPrayerTimeColumn('Fajr', prayerTimes.fajr),
              // _buildPrayerTimeColumn('Sunrise', prayerTimes.sunrise),
              _buildPrayerTimeColumn('Dhuhr', prayerTimes.dhuhr),
              _buildPrayerTimeColumn('Asr', prayerTimes.asr),
              _buildPrayerTimeColumn('Maghrib', prayerTimes.maghrib),
              _buildPrayerTimeColumn('Isha', prayerTimes.isha),
            ],
          ),
          SizedBox(height: 8.0),
          Text(
            city,
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerTimeColumn(String prayerName, String time) {
    return Column(
      children: [
        Text(
          prayerName,
          style: TextStyle(color: Colors.white54, fontSize: 12.0),
        ),
        Text(
          time,
          style: TextStyle(
              color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
