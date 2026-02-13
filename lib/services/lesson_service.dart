import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/lesson.dart';

class LessonService {
  final CollectionReference _lessonsCollection = FirebaseFirestore.instance.collection('lessons');

  // Add a new lesson or update an existing one
  Future<void> saveLesson(Lesson lesson) async {
    // If id is empty, Firestore can generate one, but Lesson model requires id currently.
    // Assuming UI generates ID or we use a specific ID strategy.
    // For now, using set with merge to create or update.
    await _lessonsCollection.doc(lesson.id).set(lesson.toMap(), SetOptions(merge: true));
  }

  // Retrieve all lessons
  Future<List<Lesson>> getLessons() async {
    try {
      QuerySnapshot snapshot = await _lessonsCollection.get();
      return snapshot.docs.map((doc) {
        return Lesson.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print("Error getting lessons: $e");
      return [];
    }
  }

  // Get a single lesson by ID
  Future<Lesson?> getLessonById(String id) async {
    try {
      DocumentSnapshot doc = await _lessonsCollection.doc(id).get();
      if (doc.exists) {
        return Lesson.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print("Error getting lesson: $e");
      return null;
    }
  }
}
