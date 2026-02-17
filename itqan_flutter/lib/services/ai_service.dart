import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/surah_model.dart';

class AiService {
  final String _baseUrl = 'http://10.0.2.2:5000';

  Future<double> predictRisk({
    required SurahModel surah,
    required int currentSessionTime,
    required int currentQuality,
  }) async {
    final url = Uri.parse('$_baseUrl/predict_risk');
    final days = DateTime.now().difference(surah.lastReviewDate).inDays;

    final Map<String, dynamic> body = {
      "surah_name": surah.name,
      "days_since_last_review": days,
      "last_review_quality": currentQuality,
      "avg_time_taken": currentSessionTime,
      "initial_difficulty": surah.initialDifficulty,
      "repetition_count": surah.repetitionCount,
      "verse_count": surah.verseCount,
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['risk_percentage'].toDouble();
    } else {
      print("Server Error: ${response.body}");
      return 0.0;
    }
  }
}
