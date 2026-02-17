import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/surah_model.dart';

class DatabaseService {
  final supabase = Supabase.instance.client;

  Future<void> signUp({required String email, required String password}) async {
    await supabase.auth.signUp(email: email, password: password);
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
        .order('page_number', ascending: true);

    List<SurahModel> surahList = [];

    for (var element in data) {
      SurahModel s = SurahModel.fromMap(element);
      surahList.add(s);
    }

    return surahList;
  }

  Future<void> addSurah({required SurahModel surah}) async {
    var dataToSend = surah.toMap();
    dataToSend['user_id'] = supabase.auth.currentUser!.id;

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
