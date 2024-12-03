import 'package:firebase_auth/firebase_auth.dart';

class AuthHelper {
  static String? get currentUserId {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid; // Returns null if the user is not logged in
  }
}