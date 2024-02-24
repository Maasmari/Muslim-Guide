import 'package:adhan/adhan.dart';

class PrayerTimesService {
  final double latitude;
  final double longitude;

  PrayerTimesService({required this.latitude, required this.longitude});

  PrayerTimes getPrayerTimes() {
    final myCoordinates = Coordinates(latitude, longitude);
    // You can adjust the calculation method based on the user's preference or location
    final params = CalculationMethod.umm_al_qura.getParameters();
    final prayerTimes = PrayerTimes.today(myCoordinates, params);

    return prayerTimes;
  }
}
