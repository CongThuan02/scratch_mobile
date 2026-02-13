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

  Map<String, dynamic> toMap() {
    return {'lessonId': lessonId, 'question': question, 'options': options, 'correctAnswerIndex': correctAnswerIndex};
  }

  factory Quiz.fromMap(Map<String, dynamic> map, String id) {
    int parseIndex(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return Quiz(
      id: id,
      lessonId: map['lessonId'] ?? '',
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctAnswerIndex: parseIndex(map['correctAnswerIndex']),
    );
  }
}
