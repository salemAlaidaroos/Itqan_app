import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:quran/quran.dart' as quran;
import '../models/surah_model.dart';

class DatabaseService {
  final supabase = Supabase.instance.client;

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    await supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': name},
    );
  }

  Future<void> login({required String email, required String password}) async {
    await supabase.auth.signInWithPassword(email: email, password: password);
  }

  String getCurrentUserId() {
    return supabase.auth.currentUser!.id;
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  Future<List<SurahModel>> getMySurahs() async {
    final data = await supabase
        .from("surahs")
        .select()
        .eq('user_id', supabase.auth.currentUser!.id)
        .order('created_at', ascending: false);

    List<SurahModel> surahList = [];
    for (var element in data) {
      surahList.add(SurahModel.fromMap(element));
    }
    return surahList;
  }

  Future<void> addSurah({
    required int surahNumber,
    required int startVerse,
    required int endVerse,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    int totalVersesToMemorize = endVerse - startVerse + 1;

    final dataToSend = {
      'user_id': user.id,
      'name': quran.getSurahNameArabic(surahNumber),
      'verse_count': totalVersesToMemorize,
      'page_number': quran.getPageNumber(surahNumber, startVerse),
      'mastery_level': 0,
      'risk_score': 0.0,
      'repetition_count': 0,
      'last_review_date': DateTime.now().toIso8601String(),
      'created_at': DateTime.now().toIso8601String(),
    };

    await supabase.from("surahs").insert(dataToSend);
  }

  Future<void> deleteSurah({required int id}) async {
    await supabase.from("surahs").delete().eq('id', id);
  }

  Future<void> updateSurahAfterReview({
    required int id,
    required int newTime,
    required int newLevel,
    required int currentRepeats,
    required double newRisk,
  }) async {
    await supabase.from("surahs").update({
      'last_time_taken': newTime,
      'mastery_level': newLevel,
      'repetition_count': currentRepeats + 1,
      'last_review_date': DateTime.now().toIso8601String(),
      'risk_score': newRisk,
    }).eq('id', id);
  }
}
