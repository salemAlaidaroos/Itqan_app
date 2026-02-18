import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import '../services/database_service.dart';
import '../models/surah_model.dart';
import 'surah_detail_screen.dart';

class MySurahsScreen extends StatefulWidget {
  const MySurahsScreen({super.key});

  @override
  State<MySurahsScreen> createState() => _MySurahsScreenState();
}

class _MySurahsScreenState extends State<MySurahsScreen> {
  final _db = DatabaseService();

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
          title: const Text("الحفظ المجدول",
              style: TextStyle(color: mainColor, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: FutureBuilder<List<SurahModel>>(
          future: _db.getMySurahs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("في خطأ: ${snapshot.error}"));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.library_books_outlined,
                        size: 80, color: Colors.grey),
                    SizedBox(height: 10),
                    Text("لم تقم بإضافة أي  حفظ بعد",
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            }

            final surahs = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: surahs.length,
              itemBuilder: (context, index) {
                final surah = surahs[index];

                return Card(
                  color: const Color(0xFFBDE8F5),
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: mainColor),
                      ),
                    ),
                    title: Text(
                      surah.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: mainColor),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        "${surah.verseCount} آيات • الصفحة ${surah.pageNumber}",
                        style: TextStyle(color: mainColor.withOpacity(0.6)),
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 18, color: mainColor),
                    onTap: () {
                      int targetSurahNumber = 1;

                      for (int i = 1; i <= 114; i++) {
                        if (quran.getSurahNameArabic(i) == surah.name) {
                          targetSurahNumber = i;
                          break;
                        }
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SurahDetailScreen(surahNumber: targetSurahNumber),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
