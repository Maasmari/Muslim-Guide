import 'dart:async';
import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';

class AdhanCountdown extends StatefulWidget {
  final Coordinates coordinates;

  AdhanCountdown({Key? key, required this.coordinates}) : super(key: key);

  @override
  _AdhanCountdownState createState() => _AdhanCountdownState();
}

class _AdhanCountdownState extends State<AdhanCountdown> {
  Timer? _timer;
  String _timeLeft = "00:00:00";
  DateTime? _nextPrayerTime;
  Prayer _nextPrayer = Prayer.fajr;

  @override
  void initState() {
    super.initState();
    _calculateNextPrayerTime();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _calculateNextPrayerTime() {
    //final now = DateTime.now();
    final prayerTimes = PrayerTimes.today(
        widget.coordinates, CalculationMethod.umm_al_qura.getParameters());
    final nextPrayer = prayerTimes.nextPrayer();
    final nextPrayerTime = prayerTimes.timeForPrayer(nextPrayer);

    setState(() {
      _nextPrayerTime = nextPrayerTime;
      _nextPrayer = nextPrayer;
    });

    if (_nextPrayerTime != null) {
      _startCountdown();
    }
  }

  void _startCountdown() {
    _timer?.cancel(); // Cancel any existing timer.
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      final now = DateTime.now();
      if (_nextPrayerTime == null || now.isAfter(_nextPrayerTime!)) {
        _calculateNextPrayerTime(); // Recalculate if time has passed.
      } else {
        final difference = _nextPrayerTime!.difference(now);
        setState(() {
          // Properly format the time left to always display two digits for hours, minutes, and seconds
          final hours = difference.inHours.toString().padLeft(2, '0');
          final minutes =
              (difference.inMinutes % 60).toString().padLeft(2, '0');
          final seconds =
              (difference.inSeconds % 60).toString().padLeft(2, '0');
          _timeLeft = "$hours:$minutes:$seconds";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var prayerName = _nextPrayer.name.toString();
    prayerName = prayerName[0].toUpperCase() + prayerName.substring(1);
    return Center(
      child: RichText(
        textAlign: TextAlign.center, // Applies to all TextSpans
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Time till $prayerName \n',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Specify the color for text
              ),
            ),
            TextSpan(
              text: '$_timeLeft',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Specify the color for text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
