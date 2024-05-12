import 'package:flutter/material.dart';
import 'package:muslim_guide/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'constant.dart';

class SurahBuilder extends StatefulWidget {
  final sura;
  final arabic;
  final suraName;
  final int ayah;

  SurahBuilder(
      {Key? key, this.sura, this.arabic, this.suraName, required this.ayah})
      : super(key: key);

  @override
  _SurahBuilderState createState() => _SurahBuilderState();
}

class _SurahBuilderState extends State<SurahBuilder> {
  bool view = true;

  late ThemeProvider themeProvider;
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => jumbToAyah());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initiate the theme provider here
    themeProvider = Provider.of<ThemeProvider>(context);
    isDarkMode = themeProvider.themeMode == ThemeMode.dark;
  }

  jumbToAyah() {
    if (fabIsClicked) {
      itemScrollController.scrollTo(
          index: widget.ayah,
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOutCubic);
    }
    fabIsClicked = false;
  }

  Row verseBuilder(int index, previousVerses) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                widget.arabic[index + previousVerses]['aya_text'],
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: arabicFontSize,
                  fontFamily: arabicFont,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [],
              ),
            ],
          ),
        ),
      ],
    );
  }

  SafeArea SingleSuraBuilder(LenghtOfSura) {
    String fullSura = '';
    int previousVerses = 0;
    if (widget.sura + 1 != 1) {
      for (int i = widget.sura - 1; i >= 0; i--) {
        previousVerses = previousVerses + noOfVerses[i];
      }
    }

    if (!view)
      for (int i = 0; i < LenghtOfSura; i++) {
        fullSura += (widget.arabic[i + previousVerses]['aya_text']);
      }

    return SafeArea(
      child: Container(
        color: isDarkMode
            ? const Color.fromARGB(255, 32, 32, 32)
            : Color.fromARGB(255, 253, 251, 240),
        child: view
            ? ScrollablePositionedList.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      (index != 0) || (widget.sura == 0) || (widget.sura == 8)
                          ? const Text('')
                          : const RetunBasmala(),
                      Container(
                        color: (index % 2 != 0 && !isDarkMode)
                            ? const Color.fromARGB(255, 253, 251,
                                240) // Light mode color for odd-indexed items
                            : (index % 2 != 0 && isDarkMode)
                                ? const Color.fromARGB(255, 32, 32,
                                    32) // Dark mode color for odd-indexed items
                                : (!isDarkMode)
                                    ? const Color.fromARGB(255, 253, 247,
                                        230) // Light mode color for even-indexed items
                                    : Color.fromARGB(255, 28, 28,
                                        28), // Dark mode color for even-indexed items

                        child: PopupMenuButton(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: verseBuilder(index, previousVerses),
                            ),
                            itemBuilder: (context) => [
                                  PopupMenuItem(
                                    onTap: () {
                                      saveBookMark(widget.sura + 1, index);
                                      //make it green
                                      // ScaffoldMessenger.of(context).showSnackBar(
                                      //     const SnackBar(
                                      //         content: Text('Bookmark Saved')));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content:
                                                const Text('Bookmark Saved'),
                                            duration:
                                                const Duration(seconds: 1),
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 56, 115, 59)),
                                      );
                                    },
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.bookmark_add,
                                          color:
                                              Color.fromARGB(255, 56, 115, 59),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text('Bookmark'),
                                      ],
                                    ),
                                  ),
                                ]),
                      ),
                    ],
                  );
                },
                itemScrollController: itemScrollController,
                itemPositionsListener: itemPositionsListener,
                itemCount: LenghtOfSura,
              )
            : ListView(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            widget.sura + 1 != 1 && widget.sura + 1 != 9
                                ? const RetunBasmala()
                                : const Text(''),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                fullSura, //mushaf mode
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: mushafFontSize,
                                  fontFamily: arabicFont,
                                  color: const Color.fromARGB(196, 44, 44, 44),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int LengthOfSura =
        noOfVerses[widget.sura]; // Assuming you have this list/map

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.suraName,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.normal,
              color: Colors.white,
              fontFamily: 'quran',
              shadows: [
                Shadow(
                  offset: Offset(1, 1),
                  blurRadius: 2.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ]),
        ),
        backgroundColor: const Color.fromARGB(255, 30, 87, 32),
        iconTheme: IconThemeData(
          color: Colors.white, // Changes the back button color to white
        ),
        // actions: <Widget>[
        //   // Mushaf Mode button on the right side
        //   Tooltip(
        //     message: 'Mushaf Mode',
        //     child: TextButton(
        //       child: const Icon(
        //         Icons.chrome_reader_mode,
        //         color: Colors.white,
        //       ),
        //       onPressed: () {
        //         setState(() {
        //           view = !view;
        //         });
        //       },
        //     ),
        //   ),
        // ],
      ),
      body: SingleSuraBuilder(
          LengthOfSura), // Assuming this is a custom widget you've defined
    );
  }
}

class RetunBasmala extends StatelessWidget {
  const RetunBasmala({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    var isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Stack(children: [
      Center(
          child: Text(
            'بسم الله الرحمن الرحيم',
            style: TextStyle(
                fontFamily: 'me_quran',
                fontSize: 30,
                color: isDarkMode ? Colors.white : Colors.black),
            textDirection: TextDirection.rtl,
          ),
          heightFactor: 1.5),
    ]);
  }
}
