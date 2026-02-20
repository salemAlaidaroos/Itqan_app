import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'surah_detail_screen.dart';

class QuranIndexScreen extends StatelessWidget {
  const QuranIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xFF0F2854);

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: 114,
        itemBuilder: (context, index) {
          int surahNum = index + 1;

          String revelationType =
              quran.getPlaceOfRevelation(surahNum) == 'Makkah'
                  ? 'مكية'
                  : 'مدنية';

          return Card(
            color: Colors.white,
            elevation: 0,
            shape: Border(bottom: BorderSide(color: Colors.grey.shade100)),
            child: ListTile(
              leading: Container(
                width: 35,
                height: 35,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFBDE8F5),
                  shape: BoxShape.circle,
                ),
                child: Text("$surahNum",
                    style: const TextStyle(
                        color: mainColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
              ),
              title: Text(
                "سورة ${quran.getSurahNameArabic(surahNum)}",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: mainColor),
              ),
              subtitle: Text(
                revelationType,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SurahDetailScreen(
                      surahNumber: surahNum,
                      isMemorizationMode: false, //
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
