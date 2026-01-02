import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/episode.dart';
import '../services/user_progress_service.dart';
import '../utils/ep_unlock_helper.dart';
import 'episode_detail_screen.dart';

class EpisodeListScreen extends StatelessWidget {
  final String chapterTitle;
  final int startEp;
  final int endEp;

  const EpisodeListScreen({
    super.key,
    required this.chapterTitle,
    required this.startEp,
    required this.endEp,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(chapterTitle)),
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
                .where('episodeNumber', isGreaterThanOrEqualTo: startEp)
                .where('episodeNumber', isLessThanOrEqualTo: endEp)
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

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EpisodeDetailScreen(episode: ep),
                          ),
                        );
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
