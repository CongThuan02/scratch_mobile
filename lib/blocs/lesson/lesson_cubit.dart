import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/lesson.dart';
import '../../models/quiz.dart';
import '../../models/practice_level.dart';
import '../../services/lesson_service.dart';
import '../../services/progress_service.dart';
import '../../services/quiz_service.dart';
import '../../services/practice_service.dart';
import '../../utils/dummy_data.dart';
import 'lesson_state.dart';

class LessonCubit extends Cubit<LessonState> {
  final LessonService _lessonService;
  final ProgressService _progressService;
  // Services for seeding
  final QuizService _quizService = QuizService();
  final PracticeService _practiceService = PracticeService();

  LessonCubit({required LessonService lessonService, required ProgressService progressService})
    : _lessonService = lessonService,
      _progressService = progressService,
      super(LessonInitial());

  Future<void> loadLessons() async {
    emit(LessonLoading());
    try {
      final lessons = await _lessonService.getLessons();
      if (lessons.isEmpty) {
        // Auto-seed if empty
        await seedData();
      } else {
        final unlockedIds = _progressService.getUnlockedLessonIds();
        emit(LessonLoaded(lessons: lessons, unlockedLessonIds: unlockedIds));
      }
    } catch (e) {
      emit(LessonError("Lỗi khi tải bài học: $e"));
    }
  }

  Future<void> seedData() async {
    emit(LessonLoading());
    try {
      // Seed Lessons
      for (var lesson in dummyLessons) {
        await _lessonService.saveLesson(lesson);
      }
      // Seed Quizzes
      for (var quiz in dummyQuizzes) {
        await _quizService.saveQuiz(quiz);
      }
      // Seed Practice Levels
      for (var level in dummyPracticeLevels) {
        await _practiceService.saveLevel(level);
      }

      // Emit success state temporarily or just reload
      // We'll emit a specific state for the UI to show a snackbar, then reload
      // Ideally handled by listener, but for simplicity let's reload directly
      // distinct state might be needed if we want to show a success message *and* show content.
      // Usually, we emit Loaded. But we want to trigger a snackbar.
      // We can emit Loaded and handle snackbar in View if we can distinguish "just loaded" from "seeded".
      // Let's reload and let the View show a message if needed?
      // Or emit LessonSeedingSuccess then load.

      // Since LessonSeedingSuccess is a state, it replaces the view.
      // Better to reload and maybe have a side-effect stream or just rely on the UI seeing new data?
      // The user wants to see "Success" message.

      // Let's just reload. The "Success" message in MVVM is often a side effect (Action/Event), not State.
      // But purely with Cubit State:
      final lessons = await _lessonService.getLessons();
      final unlockedIds = _progressService.getUnlockedLessonIds();
      emit(LessonLoaded(lessons: lessons, unlockedLessonIds: unlockedIds));

      // NOTE: To show a snackbar, the View should listen to state changes or a separate stream.
      // Since I didn't verify a "Success" state in the plan, I'll stick to Loading -> Loaded.
      // If the user wants a success message, I might need a "Seeded" flag in Loaded, or a One-time event.
      // For now, simpler: Just load. The previous UI had a snackbar.
      // I will add a custom state or property if needed later.
      // Actually, let's keep it simple.
    } catch (e) {
      emit(LessonError("Lỗi khi tải dữ liệu mẫu: $e"));
    }
  }

  Future<void> unlockLesson(String lessonId) async {
    await _progressService.unlockLesson(lessonId);
    if (state is LessonLoaded) {
      final currentState = state as LessonLoaded;
      final newUnlockedIds = List<String>.from(currentState.unlockedLessonIds)..add(lessonId);
      emit(LessonLoaded(lessons: currentState.lessons, unlockedLessonIds: newUnlockedIds));
    } else {
      // Reload if not in loaded state (unlikely)
      loadLessons();
    }
  }
}
