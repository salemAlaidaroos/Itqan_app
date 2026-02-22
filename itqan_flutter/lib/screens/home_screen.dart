import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:itqan_flutter/screens/my_surahs_screen.dart';
import 'package:itqan_flutter/screens/statistics_screen.dart';
import '../widgets/stair_card.dart';
import 'smart_review_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  void _loadUserName() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final nameFromMeta = user.userMetadata?['full_name'];
      if (nameFromMeta != null && nameFromMeta.toString().isNotEmpty) {
        setState(() {
          _userName = nameFromMeta.toString().trim().split(' ').first;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "مرحباً بك يا $_userName",
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F2854)),
              ),
              const Text(
                "✨ واصل رحله اتقانك",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: StairCard(
            title: "المراجعة الذكية",
            subtitle: "راجع بذكاء مع الذكاء الاصناعي",
            icon: Icons.psychology,
            gradientColors: const [Color(0xFF1A3A6A), Color(0xFF1C4D8D)],
            widthPercent: 1.0,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SmartReviewScreen()),
              );
            },
          ),
        ),
        Expanded(
          flex: 3,
          child: StairCard(
            title: "الحفظ المجدول",
            subtitle: "قائمة أورادك المضافة للحفظ",
            icon: Icons.calendar_today,
            gradientColors: const [Color(0xFF1C4D8D), Color(0xFF4988C4)],
            widthPercent: 0.92,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MySurahsScreen()),
              );
            },
          ),
        ),
        Expanded(
          flex: 3,
          child: StairCard(
            title: "الإحصائيات",
            subtitle: "تابع مستوى تقدمك ونقاط ضعفك",
            icon: Icons.bar_chart,
            gradientColors: const [Color(0xFF4988C4), Color(0xFFBDE8F5)],
            widthPercent: 0.84,
            textColor: const Color(0xFF0F2854),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const StatisticsScreen()),
              );
            },
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}
