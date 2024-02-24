import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';

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

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  void initState() {
    super.initState();
    determinePosition();
  }

  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
      altitude = position.altitude;
      //myCoordinates = Coordinates(latitude!, longitude!);
      myCoordinates = Coordinates(24.7136, 46.6753);
      prayerTimes = PrayerTimes.today(myCoordinates, params);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Latitude: $latitude'),
            Text('Longitude: $longitude'),
            Text('Altitude: $altitude'),
            Text('Fajr: ${DateFormat.jm().format(prayerTimes.fajr)}'),
            Text('Dhuhr: ${DateFormat.jm().format(prayerTimes.dhuhr)}'),
            Text('Asr: ${DateFormat.jm().format(prayerTimes.asr)}'),
            Text('Maghrib: ${DateFormat.jm().format(prayerTimes.maghrib)}'),
            Text('Isha: ${DateFormat.jm().format(prayerTimes.isha)}'),
          ],
        ),
      ),
    );
  }
}
