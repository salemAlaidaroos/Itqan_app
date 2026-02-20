import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/surah_model.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xFF0F2854);
    final db = DatabaseService();

    final screenHeight = MediaQuery.of(context).size.height;

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
          title: const Text("الإحصائيات ",
              style: TextStyle(color: mainColor, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: FutureBuilder<List<SurahModel>>(
          future: db.getMySurahs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: mainColor));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text("لا توجد بيانات كافية للإحصائيات بعد ",
                    style: TextStyle(color: Colors.grey, fontSize: 16)),
              );
            }

            final allSurahs = snapshot.data!;
            final memorizedSurahs =
                allSurahs.where((s) => s.repetitionCount > 0).toList();

            int totalVerses =
                memorizedSurahs.fold(0, (sum, s) => sum + s.verseCount);
            int totalMinutes =
                memorizedSurahs.fold(0, (sum, s) => sum + s.lastTimeTaken);

            double avgRisk = memorizedSurahs.isEmpty
                ? 0
                : memorizedSurahs.fold(0.0, (sum, s) => sum + s.riskScore) /
                    memorizedSurahs.length;
            int memoryStrength =
                memorizedSurahs.isEmpty ? 0 : ((1.0 - avgRisk) * 100).toInt();

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildHeroCard(
                  height: screenHeight * 0.20,
                  title: "قوة الذاكرة الحالية",
                  value: "$memoryStrength%",
                  icon: Icons.psychology,
                  color: memoryStrength > 70
                      ? Colors.green
                      : (memoryStrength > 40 ? Colors.orange : Colors.red),
                  mainColor: mainColor,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        height: screenHeight * 0.22,
                        title: "سور منجزة",
                        value: "${memorizedSurahs.length}",
                        subtitle: "سورة",
                        icon: Icons.menu_book_rounded,
                        color: Colors.blue,
                        mainColor: mainColor,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildStatCard(
                        height: screenHeight * 0.22,
                        title: "آيات محفوظة",
                        value: "$totalVerses",
                        subtitle: "آية",
                        icon: Icons.format_list_numbered_rtl,
                        color: Colors.teal,
                        mainColor: mainColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildHeroCard(
                  height: screenHeight * 0.20,
                  title: "الوقت مع القرآن",
                  value: "$totalMinutes",
                  subtitle: "دقيقة إجمالية",
                  icon: Icons.timer_outlined,
                  color: Colors.purple,
                  mainColor: mainColor,
                ),
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    "« قليلٌ دائم خيرٌ من كثير منقطع »",
                    style: TextStyle(
                        color: mainColor.withOpacity(0.5),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Amiri'),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeroCard(
      {required double height,
      required String title,
      required String value,
      String? subtitle,
      required IconData icon,
      required Color color,
      required Color mainColor}) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 25),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
                color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 40),
          ),
          const SizedBox(width: 25),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(value,
                      style: TextStyle(
                          color: mainColor,
                          fontSize: 36,
                          fontWeight: FontWeight.bold)),
                  if (subtitle != null) ...[
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(subtitle,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 14)),
                    ),
                  ]
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      {required double height,
      required String title,
      required String value,
      required String subtitle,
      required IconData icon,
      required Color color,
      required Color mainColor}) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(20),
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 30),
          ),
          const Spacer(),
          Text(title,
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value,
                  style: TextStyle(
                      color: mainColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
