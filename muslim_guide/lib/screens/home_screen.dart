import 'package:flutter/material.dart';
import 'package:muslim_guide/Widgets/last_read_card.dart';
import 'package:muslim_guide/widgets/prayer_times_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  Widget prayers = PrayerTimeCard(
    prayerTimes: PrayerTimes(
      fajr: '4:41',
      sunrise: '5:59',
      dhuhr: '11:37',
      asr: '2:50',
      maghrib: '5:14',
      isha: '6:44',
    ),
    city: 'Riyadh',
  );

  Widget lastRead = LastReadCard(
    lastRead: LastRead(
      title: 'Al-Baqarah',
      verseNumber: 285,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: prayers,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: lastRead,
            ),
          ],
        ),
      ),
    );
  }
}
