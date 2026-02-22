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

  String _getSurahText() {
    String fullText = "";
    int totalVerses = quran.getVerseCount(surahNumber);
    int start = startAyah ?? 1;

    for (int i = start; i <= totalVerses; i++) {
      fullText += "${quran.getVerse(surahNumber, i)} ﴿$i﴾ ";
    }

    return fullText;
  }

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
                onPressed: () async {
                  final result = await showDialog<bool>(
                    context: context,
                    builder: (context) => ReviewDialog(
                      surahNumber: surahNumber,
                      surahId: surahId,
                      currentRepeats: currentRepeats,
                    ),
                  );

                  if (result == true) {
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
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
                Text(
                  _getSurahText(),
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.black87,
                    height: 1.8,
                    fontFamily: 'Amiri',
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
