import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static Future<User?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithPopup(googleProvider);
        return userCredential.user;
      } else {
        return null; // 모바일은 나중에
      }
    } catch (e) {
      debugPrint('Google 로그인 에러: $e');
      return null;
    }
  }
}
