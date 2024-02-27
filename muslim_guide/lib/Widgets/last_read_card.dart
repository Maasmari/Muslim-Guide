import 'package:flutter/material.dart';
import 'package:muslim_guide/quran/constant.dart';
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

  @override
  void initState() {
    super.initState();
    readBookmarks();
  }

  void readBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      bookmarkedAyahs =
          prefs.getInt('ayah') ?? 1; // Using 1 as a fallback value
      bookmarkedSuras =
          prefs.getInt('surah') ?? 1; // Using 1 as a fallback value
    });
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
                onTap: () => widget.changeScreen?.call(
                    3), // Assuming changeScreen is a method defined in your widget class
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
