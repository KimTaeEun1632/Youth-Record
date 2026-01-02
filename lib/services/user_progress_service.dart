import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProgressService {
  /// 완료된 EP 개수 스트림 (이미 쓰고 있음)
  static Stream<int> completedEpCountStream() {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) => (doc.data()?['completedEpCount'] ?? 0) as int);
  }

  /// EP 완료 처리
  static Future<void> completeEpisode({
    required int episodeNumber,
    required String note,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

    final recordRef = userRef
        .collection('records')
        .doc(episodeNumber.toString());

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final recordSnap = await transaction.get(recordRef);

      // ✅ 이미 완료한 EP면 아무것도 안 함 (중복 방지)
      if (recordSnap.exists) {
        return;
      }

      // 1️⃣ 기록 저장
      transaction.set(recordRef, {
        'episodeNumber': episodeNumber,
        'note': note,
        'completedAt': FieldValue.serverTimestamp(),
      });

      // 2️⃣ 완료 카운트 증가
      transaction.update(userRef, {
        'completedEpCount': FieldValue.increment(1),
      });
    });
  }
}
