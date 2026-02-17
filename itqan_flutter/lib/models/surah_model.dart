class SurahModel {
  final int? id;
  final String? userId;
  final String name;
  final int pageNumber;
  final int verseCount;
  final int repetitionCount;
  final DateTime lastReviewDate;
  final int masteryLevel;
  final int initialDifficulty;
  final int lastTimeTaken;
  final double riskScore;

  SurahModel({
    this.id,
    this.userId,
    required this.name,
    required this.pageNumber,
    required this.verseCount,
    required this.lastReviewDate,
    this.repetitionCount = 0,
    this.masteryLevel = 0,
    this.initialDifficulty = 3,
    this.lastTimeTaken = 0,
    this.riskScore = 0.0,
  });

  factory SurahModel.fromMap(Map<String, dynamic> map) {
    return SurahModel(
      id: map['id'],
      userId: map['user_id'],
      name: map['name'],
      pageNumber: map['page_number'],
      verseCount: map['verse_count'],
      repetitionCount: map['repetition_count'] ?? 0,
      lastReviewDate: DateTime.parse(map['last_review_date']),
      masteryLevel: map['mastery_level'] ?? 0,
      initialDifficulty: map['initial_difficulty'] ?? 3,
      lastTimeTaken: map['last_time_taken'] ?? 0,
      riskScore: (map['risk_score'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'name': name,
      'page_number': pageNumber,
      'verse_count': verseCount,
      'repetition_count': repetitionCount,
      'last_review_date': lastReviewDate.toIso8601String(),
      'mastery_level': masteryLevel,
      'initial_difficulty': initialDifficulty,
      'last_time_taken': lastTimeTaken,
      'risk_score': riskScore,
    };
  }
}
