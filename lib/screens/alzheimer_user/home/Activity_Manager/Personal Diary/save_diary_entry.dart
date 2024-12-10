import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void saveDiaryEntry(String title, String content) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    final userId = user.uid;

    final diaryEntry = {
      'title': title,
      'content': content,
      'date': DateTime.now().toIso8601String(),
    };

    // Reference the 'diary' sub-collection under the current user's document
    final diaryRef = FirebaseFirestore.instance
        .collection('alzheimer')
        .doc(userId)
        .collection('diary');

    await diaryRef.add(diaryEntry);
  }
}
