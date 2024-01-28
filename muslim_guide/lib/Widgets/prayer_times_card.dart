import 'package:flutter/material.dart';

// Define a model for prayer times to pass to the widget
class PrayerTimes {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  PrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });
}

class PrayerTimeCard extends StatelessWidget {
  final PrayerTimes prayerTimes;
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
            'Friday 19 Rabi 2 | Nov 3', // Replace with dynamic date
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPrayerTimeColumn('Fajr', prayerTimes.fajr),
              _buildPrayerTimeColumn('Sunrise', prayerTimes.sunrise),
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
              color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
