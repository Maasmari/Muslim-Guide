import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

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
  final HijriCalendar hijriDate = HijriCalendar.now();
  final DateTime gregorianDate = DateTime.now();
  final List<String> weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
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

  String formattedDate = '${weekDays[gregorianDate.weekday - 1]} '
      '${hijriDate.hDay} ${hijriDate.longMonthName} | '
      '${gregorianMonths[gregorianDate.month - 1]} ${gregorianDate.day}';

  return formattedDate;
}

var myCoordinates;
//final myCoordinates = Coordinates(100.7136, 66.6753);
final params = CalculationMethod.umm_al_qura.getParameters();
var prayerTimes;
double? latitude;
double? longitude;
double? altitude;

double getLatitude() {
  return latitude!;
}

double getLongitude() {
  return longitude!;
}

class PrayerTimeCard extends StatefulWidget {
  final String city;

  PrayerTimeCard({required this.city});

  @override
  _PrayerTimeCardState createState() => _PrayerTimeCardState();
}

class _PrayerTimeCardState extends State<PrayerTimeCard> {
  bool _isLoading = true;
  String? _error;
  LocalPrayerTimes? _prayerTimes;

  @override
  void initState() {
    super.initState();
    determinePosition();
  }

  Future<void> determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied, we cannot request permissions.';
      }

      Position position = await Geolocator.getCurrentPosition();
      myCoordinates = Coordinates(
          position.latitude,
          position
              .longitude); // Use actual position but doesnt work in emulator
      myCoordinates = Coordinates(24.7136, 46.6753);
      prayerTimes = PrayerTimes.today(myCoordinates, params);

      // Extract the formatted prayer times
      _prayerTimes = LocalPrayerTimes(
        fajr: DateFormat.jm().format(prayerTimes.fajr),
        sunrise: DateFormat.jm().format(prayerTimes.sunrise),
        dhuhr: DateFormat.jm().format(prayerTimes.dhuhr),
        asr: DateFormat.jm().format(prayerTimes.asr),
        maghrib: DateFormat.jm().format(prayerTimes.maghrib),
        isha: DateFormat.jm().format(prayerTimes.isha),
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      // Ensure we update the state once the async operation is complete
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 39, 45, 213),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: CircularProgressIndicator(),
          ));
    }

    if (_error != null) {
      return Center(child: Text('Error: $_error'));
    }

    // If prayerTimes is still null, return an empty container or some placeholder.
    if (_prayerTimes == null) {
      return Center(child: Text('No prayer times available.'));
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 39, 45, 213),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Text(
            formatCombinedDate(),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPrayerTimeColumn('Fajr', _prayerTimes!.fajr),
              _buildPrayerTimeColumn('Dhuhr', _prayerTimes!.dhuhr),
              _buildPrayerTimeColumn('Asr', _prayerTimes!.asr),
              _buildPrayerTimeColumn('Maghrib', _prayerTimes!.maghrib),
              _buildPrayerTimeColumn('Isha', _prayerTimes!.isha),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            widget.city,
            style: const TextStyle(color: Colors.white70),
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
          style: const TextStyle(color: Colors.white54, fontSize: 12.0),
        ),
        Text(
          time,
          style: const TextStyle(
              color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
