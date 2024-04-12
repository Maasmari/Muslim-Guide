import 'package:adhan/src/coordinates.dart';
import 'package:flutter/material.dart';
import 'package:muslim_guide/providers/prayer_countdown_notifier.dart';
import 'package:provider/provider.dart';

class AdhanCountdown extends StatelessWidget {
  final Coordinates coordinates;

  AdhanCountdown({Key? key, required this.coordinates}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PrayerCountdownNotifier(coordinates as Coordinates),
      child: Consumer<PrayerCountdownNotifier>(
        builder: (context, notifier, _) {
          return Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Time till ${notifier.nextPrayer.name} \n',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: '${notifier.timeLeft}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
