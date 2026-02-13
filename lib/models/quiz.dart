class Quiz {
  final String id;
  final String lessonId;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  Quiz({
    required this.id,
    required this.lessonId,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });
}
