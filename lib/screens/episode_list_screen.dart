import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/episode.dart';
import '../services/user_progress_service.dart';
import '../utils/ep_unlock_helper.dart';

class EpisodeListScreen extends StatelessWidget {
  const EpisodeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('청춘기록')),
      body: StreamBuilder<int>(
        stream: UserProgressService.completedEpCountStream(),
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final completedCount = userSnapshot.data!;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('episodes')
                .orderBy('episodeNumber')
                .snapshots(),
            builder: (context, epSnapshot) {
              if (!epSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final episodes = epSnapshot.data!.docs.map((doc) {
                return Episode.fromFirestore(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                );
              }).toList();

              return ListView.builder(
                itemCount: episodes.length,
                itemBuilder: (context, index) {
                  final ep = episodes[index];

                  final unlocked = isEpUnlocked(
                    userCompletedCount: completedCount,
                    requiredCompletedCount: ep.requiredCompletedCount,
                  );

                  return Opacity(
                    opacity: unlocked ? 1.0 : 0.4,
                    child: ListTile(
                      leading: CircleAvatar(
                        child: unlocked
                            ? Text(ep.episodeNumber.toString())
                            : const Icon(Icons.lock),
                      ),
                      title: Text(ep.title),
                      subtitle: Text(ep.description),
                      trailing: ep.isSpecial
                          ? const Icon(Icons.star, color: Colors.amber)
                          : null,
                      onTap: () {
                        if (!unlocked) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('아직 잠겨 있는 에피소드예요 🔒')),
                          );
                          return;
                        }

                        // 🔜 다음 단계: EP 상세 화면 이동
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
