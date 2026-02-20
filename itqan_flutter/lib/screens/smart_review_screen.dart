import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../services/ai_service.dart';
import '../models/surah_model.dart';
import 'surah_detail_screen.dart';
import 'package:quran/quran.dart' as quran;

class SmartReviewScreen extends StatefulWidget {
  const SmartReviewScreen({super.key});

  @override
  State<SmartReviewScreen> createState() => _SmartReviewScreenState();
}

class _SmartReviewScreenState extends State<SmartReviewScreen> {
  final _db = DatabaseService();
  final _ai = AiService();
  bool _isAnalyzing = true;

  @override
  void initState() {
    super.initState();
    _analyzeMemory();
  }

  Future<void> _analyzeMemory() async {
    try {
      final allSurahs = await _db.getMySurahs();
      final surahsToReview =
          allSurahs.where((s) => s.repetitionCount > 0).toList();

      for (var surah in surahsToReview) {
        double currentRisk = await _ai.predictRisk(
          surah: surah,
          currentSessionTime:
              surah.lastTimeTaken == 0 ? 10 : surah.lastTimeTaken,
          currentQuality: surah.masteryLevel == 0 ? 3 : surah.masteryLevel,
        );

        await _db.updateSurahAfterReview(
          id: surah.id!,
          newTime: surah.lastTimeTaken,
          newLevel: surah.masteryLevel,
          currentRepeats: surah.repetitionCount,
          newRisk: currentRisk,
        );
      }
    } catch (e) {
      print("AI Analysis Error: $e");
    }

    if (mounted) {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

  void _deleteItem(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("حذف الورد", textAlign: TextAlign.right),
        content: const Text("هل أنت متأكد أنك تريد حذف هذا الورد من المراجعة؟"),
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
                  const SnackBar(content: Text("تم الحذف بنجاح 🗑️")),
                );
              }
            },
            child: const Text("حذف", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Color _getRiskColor(double risk) {
    if (risk >= 0.7) return Colors.redAccent;
    if (risk >= 0.4) return Colors.orangeAccent;
    return Colors.green;
  }

  String _getDifficultyText(int level) {
    switch (level) {
      case 1:
        return "صعب جداً";
      case 2:
        return "صعب";
      case 3:
        return "مقبول";
      case 4:
        return "جيد";
      case 5:
        return "ممتاز";
      default:
        return "جديد";
    }
  }

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xFF0F2854);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: mainColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text("المراجعة الذكية",
              style: TextStyle(color: mainColor, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: _isAnalyzing
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: mainColor),
                    const SizedBox(height: 20),
                    Text("جاري تحليل الذاكرة بالذكاء الاصطناعي... ",
                        style: TextStyle(
                            color: mainColor.withOpacity(0.7),
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            : FutureBuilder<List<SurahModel>>(
                future: _db.getMySurahs(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("لا يوجد سور للمراجعة حالياً ",
                          style: TextStyle(color: Colors.grey, fontSize: 16)),
                    );
                  }

                  final allSurahs = snapshot.data!;
                  final surahs =
                      allSurahs.where((s) => s.repetitionCount > 0).toList();

                  if (surahs.isEmpty) {
                    return const Center(
                      child: Text(
                          "لا توجد سور للمراجعة حالياً، ابدأ بحفظ ورد جديد",
                          style: TextStyle(color: Colors.grey, fontSize: 16)),
                    );
                  }

                  surahs.sort((a, b) => b.riskScore.compareTo(a.riskScore));

                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: surahs.length,
                    itemBuilder: (context, index) {
                      final surah = surahs[index];

                      double risk = surah.riskScore;
                      if (risk <= 0) risk = 0.05;

                      Color riskColor = _getRiskColor(risk);

                      final int daysSinceReview = DateTime.now()
                          .difference(surah.lastReviewDate)
                          .inDays;
                      String daysText;
                      if (daysSinceReview == 0)
                        daysText = "اليوم";
                      else if (daysSinceReview == 1)
                        daysText = "أمس";
                      else if (daysSinceReview == 2)
                        daysText = "يومين";
                      else
                        daysText = "$daysSinceReview أيام";

                      return InkWell(
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
                            setState(() => _isAnalyzing = true);
                            _analyzeMemory();
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5)),
                            ],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: mainColor.withOpacity(0.1),
                                              shape: BoxShape.circle),
                                          child: Text("${index + 1}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: mainColor)),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(surah.name,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: mainColor)),
                                            Text("${surah.verseCount} آيات",
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                          color: riskColor.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Text(
                                        "النسيان ${(risk * 100).toInt()}%",
                                        style: TextStyle(
                                            color: riskColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: risk,
                                    backgroundColor: Colors.grey[200],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        riskColor),
                                    minHeight: 8,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF5F8FC),
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20)),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildInfoItem(
                                        Icons.star,
                                        _getDifficultyText(surah.masteryLevel),
                                        Colors.amber),
                                    _buildInfoItem(
                                        Icons.repeat,
                                        "${surah.repetitionCount} مرات",
                                        Colors.blue),
                                    _buildInfoItem(Icons.calendar_today,
                                        daysText, Colors.teal),
                                    InkWell(
                                      onTap: () => _deleteItem(surah.id!),
                                      child: const Icon(Icons.delete_outline,
                                          color: Colors.red, size: 22),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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

  Widget _buildInfoItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(text,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F2854))),
      ],
    );
  }
}
