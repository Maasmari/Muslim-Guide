import 'dart:async';
import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';

class PrayerCountdownNotifier with ChangeNotifier {
  Timer? _timer;
  String timeLeft = "00:00:00";
  DateTime? nextPrayerTime;
  Prayer nextPrayer = Prayer.fajr;
  Coordinates coordinates;

  PrayerCountdownNotifier(this.coordinates) {
    calculateNextPrayerTime();
  }

  void calculateNextPrayerTime() {
    final prayerTimes = PrayerTimes.today(
        coordinates, CalculationMethod.umm_al_qura.getParameters());
    final nextPrayer = prayerTimes.nextPrayer();
    final nextPrayerTime = prayerTimes.timeForPrayer(nextPrayer);

    if (this.nextPrayerTime != nextPrayerTime) {
      this.nextPrayerTime = nextPrayerTime;
      this.nextPrayer = nextPrayer;
      startCountdown();
    }
  }

  void startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (_) => updateTime());
  }

  void updateTime() {
    final now = DateTime.now();
    if (nextPrayerTime == null || now.isAfter(nextPrayerTime!)) {
      calculateNextPrayerTime();
    } else {
      final difference = nextPrayerTime!.difference(now);
      final hours = difference.inHours.toString().padLeft(2, '0');
      final minutes = (difference.inMinutes % 60).toString().padLeft(2, '0');
      final seconds = (difference.inSeconds % 60).toString().padLeft(2, '0');
      timeLeft = "$hours:$minutes:$seconds";
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
