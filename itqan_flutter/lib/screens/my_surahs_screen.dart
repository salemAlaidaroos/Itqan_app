import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/surah_model.dart';
import 'surah_detail_screen.dart';
import 'package:quran/quran.dart' as quran;

class MySurahsScreen extends StatefulWidget {
  const MySurahsScreen({super.key});

  @override
  State<MySurahsScreen> createState() => _MySurahsScreenState();
}

class _MySurahsScreenState extends State<MySurahsScreen> {
  final _db = DatabaseService();

  void _deleteItem(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("حذف الورد", textAlign: TextAlign.right),
        content: const Text("هل أنت متأكد أنك تريد حذف هذا الورد نهائياً؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _db.deleteSurah(id: id);
              setState(() {});
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("تم الحذف بنجاح ")),
                );
              }
            },
            child: const Text("حذف", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
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
              return Center(child: Text("حدث خطأ: ${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildEmptyState();
            }

            final allSurahs = snapshot.data!;

            final surahs = allSurahs.where((s) {
              final now = DateTime.now();
              final lastReview = s.lastReviewDate;

              bool isToday = lastReview.year == now.year &&
                  lastReview.month == now.month &&
                  lastReview.day == now.day;

              if (isToday && s.repetitionCount > 0) {
                return false;
              }
              return true;
            }).toList();

            if (surahs.isEmpty) {
              return const Center(
                child: Text("أتممت وردك اليوم، يا بطل!",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
              );
            }

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
                      child: Text("${index + 1}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: mainColor)),
                    ),
                    title: Text(
                      surah.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: mainColor),
                    ),
                    subtitle: Text(
                      "${surah.verseCount} آيات",
                      style: TextStyle(color: mainColor.withOpacity(0.6)),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _deleteItem(surah.id!),
                    ),
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
                          builder: (context) => SurahDetailScreen(
                            surahNumber: targetSurahNumber,
                            isMemorizationMode: true,
                            surahId: surah.id,
                            currentRepeats: surah.repetitionCount,
                          ),
                        ),
                      ).then((_) {
                        setState(() {});
                      });
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

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.library_books_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 10),
          Text("لا يوجد سور محفوظة حالياً",
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
