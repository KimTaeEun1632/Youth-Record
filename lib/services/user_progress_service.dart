import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProgressService {
  /// ✅ 완료된 EP 개수 스트림
  static Stream<int> completedEpCountStream() {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) => (doc.data()?['completedEpCount'] ?? 0) as int);
  }

  /// ✅ EP 완료 (신규 작성)
  static Future<void> completeEpisode({
    required int episodeNumber,
    required String note,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

    final recordRef = userRef
        .collection('records')
        .doc(episodeNumber.toString());

    // 기록 저장
    await recordRef.set({
      'episodeNumber': episodeNumber,
      'note': note,
      'completedAt': FieldValue.serverTimestamp(),
    });

    // 완료 개수 증가
    await userRef.update({'completedEpCount': FieldValue.increment(1)});
  }

  /// ✅ 기존 EP 기록 불러오기
  static Future<String?> getEpisodeNote(int episodeNumber) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('records')
        .doc(episodeNumber.toString())
        .get();

    if (!doc.exists) return null;

    return doc.data()?['note'] as String?;
  }

  /// ✅ 기존 EP 기록 수정
  static Future<void> updateEpisodeNote({
    required int episodeNumber,
    required String note,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('records')
        .doc(episodeNumber.toString())
        .update({'note': note, 'updatedAt': FieldValue.serverTimestamp()});
  }
}
