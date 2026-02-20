import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import '../widgets/review_dialog.dart';

class SurahDetailScreen extends StatelessWidget {
  final int surahNumber;
  final int? startAyah;
  final bool isMemorizationMode;

  final int? surahId;
  final int? currentRepeats;

  const SurahDetailScreen({
    super.key,
    required this.surahNumber,
    this.startAyah,
    this.isMemorizationMode = false,
    this.surahId,
    this.currentRepeats,
  });

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xFF0F2854);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: mainColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "سورة ${quran.getSurahNameArabic(surahNumber)}",
            style:
                const TextStyle(color: mainColor, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        floatingActionButton: isMemorizationMode
            ? FloatingActionButton.extended(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => ReviewDialog(
                      surahNumber: surahNumber,
                      surahId: surahId,
                      currentRepeats: currentRepeats,
                    ),
                  ).then((_) {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  });
                },
                backgroundColor: mainColor,
                icon:
                    const Icon(Icons.check_circle_outline, color: Colors.white),
                label: const Text(
                  "أتممت الحفظ",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )
            : null,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView(
              children: [
                if (surahNumber != 1 && surahNumber != 9)
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    alignment: Alignment.center,
                    child: const Text(
                      "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Amiri',
                        color: mainColor,
                      ),
                    ),
                  ),
                RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    children: List.generate(quran.getVerseCount(surahNumber),
                        (index) {
                      int verseNum = index + 1;
                      return TextSpan(
                        children: [
                          TextSpan(
                            text: quran.getVerse(surahNumber, verseNum),
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.black87,
                              height: 1.8,
                              fontFamily: 'Amiri',
                            ),
                          ),
                          TextSpan(
                            text: " ﴿$verseNum﴾ ",
                            style: const TextStyle(
                              color: mainColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
