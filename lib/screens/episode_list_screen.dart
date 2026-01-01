import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/episode.dart';

class EpisodeListScreen extends StatelessWidget {
  const EpisodeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('청춘기록')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('episodes')
            .orderBy('episodeNumber')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('에피소드가 없습니다.'));
          }

          final episodes = snapshot.data!.docs.map((doc) {
            return Episode.fromFirestore(
              doc.id,
              doc.data() as Map<String, dynamic>,
            );
          }).toList();

          return ListView.builder(
            itemCount: episodes.length,
            itemBuilder: (context, index) {
              final ep = episodes[index];

              return ListTile(
                leading: CircleAvatar(child: Text(ep.episodeNumber.toString())),
                title: Text(ep.title),
                subtitle: Text(ep.description),
                trailing: ep.isSpecial
                    ? const Icon(Icons.star, color: Colors.amber)
                    : null,
                onTap: () {
                  // 다음 단계: EP 상세 화면으로 이동
                },
              );
            },
          );
        },
      ),
    );
  }
}
