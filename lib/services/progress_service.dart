import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static final ProgressService _instance = ProgressService._internal();

  factory ProgressService() {
    return _instance;
  }

  ProgressService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- Unlocked Lessons ---

  static const String _unlockedLessonsKey = 'unlocked_lessons';

  List<String> getUnlockedLessonIds() {
    return _prefs?.getStringList(_unlockedLessonsKey) ?? ['1']; // Lesson 1 is default
  }

  Future<void> unlockLesson(String lessonId) async {
    final currentList = getUnlockedLessonIds();
    if (!currentList.contains(lessonId)) {
      currentList.add(lessonId);
      await _prefs?.setStringList(_unlockedLessonsKey, currentList);
    }
  }

  bool isLessonUnlocked(String lessonId) {
    return getUnlockedLessonIds().contains(lessonId);
  }

  // --- Quiz Scores ---

  // Key format: quiz_score_<lessonId>
  String _getQuizScoreKey(String lessonId) => 'quiz_score_$lessonId';

  int getQuizScore(String lessonId) {
    return _prefs?.getInt(_getQuizScoreKey(lessonId)) ?? 0;
  }

  Future<void> saveQuizScore(String lessonId, int score) async {
    final currentHighScore = getQuizScore(lessonId);
    if (score > currentHighScore) {
      await _prefs?.setInt(_getQuizScoreKey(lessonId), score);
    }
  }
}
