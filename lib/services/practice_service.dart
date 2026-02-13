import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/practice_level.dart';

class PracticeService {
  final CollectionReference _levelsCollection = FirebaseFirestore.instance.collection('practice_levels');

  Future<void> saveLevel(PracticeLevel level) async {
    await _levelsCollection.doc(level.id).set(level.toMap(), SetOptions(merge: true));
  }

  Future<List<PracticeLevel>> getLevels() async {
    try {
      QuerySnapshot snapshot = await _levelsCollection.get();
      return snapshot.docs.map((doc) {
        return PracticeLevel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print("Error getting practice levels: $e");
      return [];
    }
  }
}
