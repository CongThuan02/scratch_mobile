import 'package:equatable/equatable.dart';
import '../../models/lesson.dart';

abstract class LessonState extends Equatable {
  const LessonState();

  @override
  List<Object> get props => [];
}

class LessonInitial extends LessonState {}

class LessonLoading extends LessonState {}

class LessonLoaded extends LessonState {
  final List<Lesson> lessons;
  final List<String> unlockedLessonIds;

  const LessonLoaded({required this.lessons, required this.unlockedLessonIds});

  @override
  List<Object> get props => [lessons, unlockedLessonIds];
}

class LessonError extends LessonState {
  final String message;

  const LessonError(this.message);

  @override
  List<Object> get props => [message];
}

class LessonSeedingSuccess extends LessonState {
  final String message;

  const LessonSeedingSuccess(this.message);

  @override
  List<Object> get props => [message];
}
