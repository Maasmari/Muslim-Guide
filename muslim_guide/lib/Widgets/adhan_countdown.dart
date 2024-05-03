import 'package:adhan/src/coordinates.dart';
import 'package:flutter/material.dart';
import 'package:muslim_guide/providers/prayer_countdown_notifier.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

final brightness =
    WidgetsBinding.instance.platformDispatcher.platformBrightness;
bool isDarkMode = brightness == Brightness.dark;

class AdhanCountdown extends StatelessWidget {
  final Coordinates coordinates;

  AdhanCountdown({Key? key, required this.coordinates}) : super(key: key);

  Color Checkdarkmode() {
    Color textcolor = Colors.black;
    if (isDarkMode) {
      textcolor = Colors.white;
    }
    return textcolor;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context,
        listen: true); // Access the ThemeProvider
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    return ChangeNotifierProvider(
      create: (_) => PrayerCountdownNotifier(coordinates),
      child: Consumer<PrayerCountdownNotifier>(
        builder: (context, notifier, _) {
          return Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Time till ${notifier.nextPrayer?.name} \n',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? Color.fromARGB(255, 255, 255, 255)
                          : const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  TextSpan(
                    text: '${notifier.timeLeft}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? Color.fromARGB(255, 255, 255, 255)
                          : const Color.fromARGB(255, 0, 0, 0),
                    ),
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
