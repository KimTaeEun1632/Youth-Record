import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'episode_list_screen.dart';

class ChapterListScreen extends StatelessWidget {
  const ChapterListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('청춘기록')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chapters')
            .orderBy('chapterNumber')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final chapters = snapshot.data!.docs;

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .get(),
            builder: (context, userSnapshot) {
              if (!userSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final completedEpCount =
                  (userSnapshot.data!['completedEpCount'] ?? 0) as int;

              return ListView.builder(
                itemCount: chapters.length,
                itemBuilder: (context, index) {
                  final chapter = chapters[index];
                  final isFinal = chapter['isFinal'] ?? false;

                  bool isLocked = false;
                  if (isFinal) {
                    final required = chapter['requiredCompletedCount'] ?? 0;
                    isLocked = completedEpCount < required;
                  }

                  return ChapterCard(
                    title: chapter['title'],
                    description: chapter['description'],
                    isLocked: isLocked,
                    onTap: isLocked
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EpisodeListScreen(
                                  chapterTitle: chapter['title'],
                                  startEp: chapter['startEp'],
                                  endEp: chapter['endEp'],
                                ),
                              ),
                            );
                          },
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

class ChapterCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isLocked;
  final VoidCallback? onTap;

  const ChapterCard({
    super.key,
    required this.title,
    required this.description,
    required this.isLocked,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isLocked ? 0.5 : 1,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(description),
          trailing: isLocked
              ? const Icon(Icons.lock)
              : const Icon(Icons.arrow_forward_ios),
          onTap: onTap,
        ),
      ),
    );
  }
}
