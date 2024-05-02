import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:muslim_guide/providers/theme_provider.dart'; // Ensure this import is correct
// import 'quran.dart';
import 'surah_builder.dart';
import 'constant.dart';
import 'package:muslim_guide/quran/arabic_sura_number.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    // Access the ThemeProvider to determine if the theme is dark
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Go to bookmark',
        child: const Icon(Icons.bookmark, color: Colors.white),
        backgroundColor: Color.fromARGB(255, 44, 112, 47),
        onPressed: () async {
          fabIsClicked = true;
          if (await readBookmark() == true) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SurahBuilder(
                          arabic: quran[0],
                          sura: bookmarkedSura - 1,
                          suraName: arabicName[bookmarkedSura - 1]['name'],
                          ayah: bookmarkedAyah,
                        )));
          }
        },
      ),
      appBar: AppBar(
        title:
            Text('Quran', style: TextStyle(color: Colors.white, fontSize: 26)),
        backgroundColor: Color.fromARGB(255, 30, 87, 32),
      ),
      body: FutureBuilder(
        future: readJson(), // Placeholder for actual future
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Text('Error');
          } else if (snapshot.hasData) {
            return indexCreator(snapshot.data, context, isDarkMode);
          } else {
            return const Text('Empty data');
          }
        },
      ),
    );
  }

  Widget indexCreator(dynamic quran, BuildContext context, bool isDarkMode) {
    final backgroundColor = isDarkMode
        ? Color.fromARGB(255, 33, 33, 33)
        : Color.fromARGB(255, 221, 250, 236);
    final itemColorOdd = isDarkMode
        ? Color.fromARGB(255, 32, 32, 32)
        : Color.fromARGB(255, 253, 251, 240);
    final itemColorEven = isDarkMode
        ? Color.fromARGB(255, 28, 28, 28)
        : Color.fromARGB(255, 253, 247, 230);
    final textColor =
        isDarkMode ? const Color.fromARGB(255, 217, 216, 216) : Colors.black87;

    return Container(
      color: backgroundColor,
      child: ListView.builder(
        itemCount: 114, // Assuming there are 114 items
        itemBuilder: (context, index) {
          return Container(
            color: index % 2 == 0 ? itemColorEven : itemColorOdd,
            child: TextButton(
              child: Row(
                children: [
                  ArabicSuraNumber(i: index),
                  const SizedBox(width: 5),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [],
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Text(
                    arabicName[index]['name'], // Example placeholder
                    style: TextStyle(
                      fontSize: 30,
                      color: textColor,
                      fontFamily: 'quran',
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
              onPressed: () {
                fabIsClicked = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SurahBuilder(
                            arabic: quran[0],
                            sura: index,
                            suraName: arabicName[index]['name'],
                            ayah: 0,
                          )),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
