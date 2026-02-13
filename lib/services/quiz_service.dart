import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz.dart';

class QuizService {
  final CollectionReference _quizzesCollection = FirebaseFirestore.instance.collection('quizzes');

  Future<void> saveQuiz(Quiz quiz) async {
    await _quizzesCollection.doc(quiz.id).set(quiz.toMap(), SetOptions(merge: true));
  }

  Future<List<Quiz>> getQuizzesByLessonId(String lessonId) async {
    try {
      QuerySnapshot snapshot = await _quizzesCollection.where('lessonId', isEqualTo: lessonId).get();
      return snapshot.docs.map((doc) {
        return Quiz.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print("Error getting quizzes: $e");
      return [];
    }
  }
}
