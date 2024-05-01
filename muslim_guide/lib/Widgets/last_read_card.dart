import 'dart:async';
import 'package:flutter/material.dart';
import 'package:muslim_guide/publishers/event_publisher.dart';
import 'package:muslim_guide/quran/constant.dart';
import 'package:muslim_guide/quran/surah_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LastReadCard extends StatefulWidget {
  final Function? changeScreen;
  LastReadCard({Key? key, this.changeScreen}) : super(key: key);

  @override
  _LastReadCardState createState() => _LastReadCardState();
}

class _LastReadCardState extends State<LastReadCard> {
  int bookmarkedAyahs = 1;
  int bookmarkedSuras = 1;
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    readBookmarks();
    _subscription = EventPublisher().onEvent.listen((event) {
      if (event == 'updateBookmarks') {
        readBookmarks();
      }
    });
  }

  void readBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      bookmarkedAyahs = prefs.getInt('ayah') ?? 1;
      bookmarkedSuras = prefs.getInt('surah') ?? 1;
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  String getSurahName(int surahNumber) {
    String StringsurahNumber = surahNumber.toString();
    for (var surah in arabicName) {
      if (surah["surah"] == StringsurahNumber) {
        return surah["name"];
      }
    }
    return "null";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 47, 160, 51),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Last Read',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () async => {
                  widget.changeScreen?.call(4),
                  // if (await readBookmark() == true)
                  //   {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => SurahBuilder(
                  //                   arabic: quran[0],
                  //                   sura: bookmarkedSura - 1,
                  //                   suraName: arabicName[bookmarkedSura - 1]
                  //                       ['name'],
                  //                   ayah: bookmarkedAyah,
                  //                 )))
                  //   }
                }, // Assuming changeScreen is a method defined in your widget class
                child: Icon(Icons.arrow_forward_ios,
                    color: Colors.white, size: 30.0),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Text(
            "Surah: " +
                getSurahName(
                    bookmarkedSuras), // Adjusted variable name to match the context
            style: TextStyle(
              color: Color.fromARGB(222, 255, 255, 255),
              //fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          Text(
            'Ayah No: ${bookmarkedAyahs + 1}', // Adjusted variable name to match the context
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11.0,
            ),
          ),
        ],
      ),
    );
  }
}
