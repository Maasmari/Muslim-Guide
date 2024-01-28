import 'package:flutter/material.dart';

class LastRead {
  final String title;
  final int verseNumber;

  LastRead({required this.title, required this.verseNumber});
}

class LastReadCard extends StatelessWidget {
  final LastRead lastRead;

  LastReadCard({required this.lastRead});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: Colors.green, // Adjust the color to match your design
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
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
          Text(
            'Last Read',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            "Al-Baqarah",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          Text(
            'Ayah No: 285',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}
