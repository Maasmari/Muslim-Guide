import 'dart:async';
import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';

class PrayerCountdownNotifier with ChangeNotifier {
  Timer? _timer;
  String timeLeft = "00:00:00";
  DateTime? nextPrayerTime;
  Prayer? nextPrayer;
  Coordinates coordinates;

  PrayerCountdownNotifier(this.coordinates) {
    calculateNextPrayerTime();
  }
  void calculateNextPrayerTime() {
    final now = DateTime.now();
    final prayerTimes = PrayerTimes.today(
      coordinates,
      CalculationMethod.umm_al_qura.getParameters(),
    );

    nextPrayer = prayerTimes.nextPrayerByDateTime(now);

    if (nextPrayer == null || nextPrayer == Prayer.none) {
      // When no more prayers are left today, schedule for Fajr the next day
      final tomorrow = now.add(Duration(days: 1));
      final tomorrowDateComponents = DateComponents.from(tomorrow);
      final tomorrowPrayerTimes = PrayerTimes(
        coordinates,
        tomorrowDateComponents,
        CalculationMethod.umm_al_qura.getParameters(),
      );
      nextPrayerTime = tomorrowPrayerTimes.timeForPrayer(Prayer.fajr);
      nextPrayer =
          Prayer.fajr; // Ensure nextPrayer is set to Fajr for the next day
    } else {
      nextPrayerTime = prayerTimes.timeForPrayer(nextPrayer!);
    }

    if (nextPrayerTime != null) {
      startCountdown();
    }
  }

  void startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (_) => updateTime());
  }

  void updateTime() {
    final now = DateTime.now();
    final difference = nextPrayerTime!.difference(now);

    if (difference.isNegative) {
      calculateNextPrayerTime();
    } else {
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
