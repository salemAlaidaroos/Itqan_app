import 'package:flutter/material.dart';
import 'package:itqan_flutter/screens/my_surahs_screen.dart';
import '../widgets/stair_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 40, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "مرحباً بك  ",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F2854)),
              ),
              Text("واصل رحلة إتقانك", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: StairCard(
            title: "المراجعة الذكية",
            subtitle: "3 سور تنتظر المراجعة",
            icon: Icons.psychology,
            gradientColors: const [Color(0xFF1A3A6A), Color(0xFF1C4D8D)],
            widthPercent: 1.0,
            onTap: () {},
          ),
        ),
        Expanded(
          flex: 3,
          child: StairCard(
            title: "الحفظ المجدول",
            subtitle: "وردك اليوم: سورة الكهف",
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
            subtitle: "إجمالي الحفظ: 5 أجزاء",
            icon: Icons.bar_chart,
            gradientColors: const [Color(0xFF4988C4), Color(0xFFBDE8F5)],
            widthPercent: 0.84,
            textColor: const Color(0xFF0F2854),
            onTap: () {},
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}
