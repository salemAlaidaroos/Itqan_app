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

  void _deleteItem(int id) async {
    await _db.deleteSurah(id: id);
    setState(() {});
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم حذف الورد بنجاح ✅"),
          backgroundColor: Colors.red,
        ),
      );
    }
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

            final surahs =
                allSurahs.where((s) => s.repetitionCount == 0).toList();

            if (surahs.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: surahs.length,
              itemBuilder: (context, index) {
                final surah = surahs[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFBDE8F5).withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: mainColor.withOpacity(0.3), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        spreadRadius: 0,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      leading: Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: mainColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text("${index + 1}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18)),
                      ),
                      title: Text(
                        surah.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: mainColor),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: [
                            Icon(Icons.format_list_numbered_rtl,
                                size: 18, color: mainColor.withOpacity(0.7)),
                            const SizedBox(width: 6),
                            Text(
                              "من آية ${surah.startVerse} إلى ${surah.endVerse}",
                              style: TextStyle(
                                color: mainColor.withOpacity(0.8),
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.red, size: 28),
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
                              startAyah: surah.startVerse,
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
          Text("لا يوجد أوراد مجدولة حالياً",
              style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}
