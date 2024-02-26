import 'package:flutter/material.dart';
import 'package:muslim_guide/quran/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LastRead {
  final String title;
  final int verseNumber;

  LastRead({required this.title, required this.verseNumber});
}

class LastReadCard extends StatelessWidget {
  final LastRead lastRead;

  int bookmarkedAyahs = 1;
  int bookmarkedSuras = 1;

  LastReadCard({required this.lastRead});

  @override
  Widget build(BuildContext context) {
    String getSurahName(int surahNumber) {
      String StringsurahNumber = surahNumber.toString();
      for (var surah in arabicName) {
        if (surah["surah"] == StringsurahNumber) {
          return surah["name"];
        }
      }
      return "null";
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(
            255, 47, 160, 51), // Adjust the color to match your design
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
              Icon(Icons.arrow_forward_ios, color: Colors.white, size: 30.0),
            ],
          ),
          SizedBox(height: 10.0),
          Text(
            getSurahName(bookmarkedSura),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          Text(
            'Ayah No: ${bookmarkedAyah + 1}',
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
