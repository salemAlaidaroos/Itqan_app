import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../services/ai_service.dart';
import '../models/surah_model.dart';

class ReviewDialog extends StatefulWidget {
  final int surahNumber;
  final int? surahId;
  final int? currentRepeats;

  const ReviewDialog({
    super.key,
    required this.surahNumber,
    this.surahId,
    this.currentRepeats,
  });

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  int _selectedQuality = 3;
  int _timeCounter = 10;
  bool _isLoading = false;

  final _db = DatabaseService();
  final _ai = AiService();

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xFF0F2854);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Center(
          child: Text("تقييم الحفظ",
              style: TextStyle(fontWeight: FontWeight.bold, color: mainColor)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("كيف كان مستوى حفظك؟",
                style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFaceOption(
                    1, Icons.sentiment_very_dissatisfied, Colors.red),
                _buildFaceOption(
                    2, Icons.sentiment_dissatisfied, Colors.orange),
                _buildFaceOption(3, Icons.sentiment_neutral, Colors.amber),
                _buildFaceOption(
                    4, Icons.sentiment_satisfied, Colors.lightGreen),
                _buildFaceOption(
                    5, Icons.sentiment_very_satisfied, Colors.green),
              ],
            ),
            const Divider(height: 30),
            const Text("الوقت المستغرق (دقائق)",
                style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline,
                        color: mainColor),
                    onPressed: () {
                      if (_timeCounter > 5) setState(() => _timeCounter -= 5);
                    },
                  ),
                  Text(
                    "$_timeCounter دقيقة",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: mainColor),
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.add_circle_outline, color: mainColor),
                    onPressed: () {
                      setState(() => _timeCounter += 5);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("إلغاء", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: _isLoading
                ? null
                : () async {
                    if (widget.surahId == null) {
                      Navigator.pop(context, false);
                      return;
                    }

                    setState(() => _isLoading = true);

                    try {
                      final surahs = await _db.getMySurahs();
                      final surahModel =
                          surahs.firstWhere((s) => s.id == widget.surahId);

                      double predictedRisk = await _ai.predictRisk(
                        surah: surahModel,
                        currentSessionTime: _timeCounter,
                        currentQuality: _selectedQuality,
                      );

                      await _db.updateSurahAfterReview(
                        id: widget.surahId!,
                        newTime: _timeCounter,
                        newLevel: _selectedQuality,
                        currentRepeats: surahModel.repetitionCount,
                        newRisk: predictedRisk,
                      );
                      if (mounted) {
                        Navigator.pop(context, true);
                      }
                    } catch (error) {
                      setState(() => _isLoading = false);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("تعذر الاتصال، تأكد من الإنترنت!"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: mainColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))
                : const Text("تأكيد", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildFaceOption(int value, IconData icon, Color color) {
    bool isSelected = _selectedQuality == value;

    return IconButton(
      icon: Icon(
        icon,
        size: isSelected ? 35 : 30,
        color: isSelected ? color : Colors.grey,
      ),
      onPressed: () {
        setState(() {
          _selectedQuality = value;
        });
      },
    );
  }
}
