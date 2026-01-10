import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chapter.dart';
import '../models/episode.dart';
import '../services/user_progress_service.dart';
import '../utils/ep_unlock_helper.dart';
import 'episode_detail_screen.dart';

class EpisodeListScreen extends StatelessWidget {
  final Chapter chapter;

  const EpisodeListScreen({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    final totalCount = chapter.endEp - chapter.startEp + 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
        centerTitle: true,
        title: Text(
          chapter.title.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: StreamBuilder<int>(
        stream: UserProgressService.completedEpCountStream(),
        builder: (context, countSnapshot) {
          if (!countSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final completedCount = countSnapshot.data!;
          final completedInChapter =
              completedCount.clamp(chapter.startEp - 1, chapter.endEp) -
              (chapter.startEp - 1);
          final progress = completedInChapter / totalCount;

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🟧 Hero Section
                _HeroSection(chapter: chapter),

                /// 🟧 Progress Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'CHAPTER COMPLETION',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '$completedInChapter / $totalCount',
                            style: const TextStyle(
                              color: Color(0xFFEE8C2B),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(8),
                        backgroundColor: Colors.grey.shade300,
                        color: const Color(0xFFEE8C2B),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// 🟧 Episode List Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: const [
                      Icon(Icons.auto_stories, color: Color(0xFFEE8C2B)),
                      SizedBox(width: 6),
                      Text(
                        '에피소드 목록',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                /// 🟧 Episode List
                StreamBuilder<Set<int>>(
                  stream: UserProgressService.completedEpisodeSetStream(),
                  builder: (context, completedSnapshot) {
                    if (!completedSnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final completedSet = completedSnapshot.data!;

                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('episodes')
                          .where(
                            'episodeNumber',
                            isGreaterThanOrEqualTo: chapter.startEp,
                            isLessThanOrEqualTo: chapter.endEp,
                          )
                          .orderBy('episodeNumber')
                          .snapshots(),
                      builder: (context, epSnapshot) {
                        if (!epSnapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final episodes = epSnapshot.data!.docs
                            .map(
                              (doc) => Episode.fromFirestore(
                                doc.id,
                                doc.data() as Map<String, dynamic>,
                              ),
                            )
                            .toList();

                        return Column(
                          children: episodes.map((ep) {
                            final isCompleted = completedSet.contains(
                              ep.episodeNumber,
                            );
                            final unlocked = isEpUnlocked(
                              userCompletedCount: completedCount,
                              requiredCompletedCount: ep.requiredCompletedCount,
                            );

                            return _EpisodeCard(
                              episode: ep,
                              isCompleted: isCompleted,
                              unlocked: unlocked,
                              onTap: () {
                                if (!unlocked) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('아직 잠겨 있는 에피소드예요 🔒'),
                                    ),
                                  );
                                  return;
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EpisodeDetailScreen(episode: ep),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/* ------------------------------------------------------ */
/* Hero Section                                           */
/* ------------------------------------------------------ */

class _HeroSection extends StatelessWidget {
  final Chapter chapter;

  const _HeroSection({required this.chapter});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    chapter.coverAssets,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                right: 12,
                child: Transform.rotate(
                  angle: -0.05,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEE8C2B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'COLLECTION',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            chapter.subTitle,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            chapter.description,
            style: TextStyle(color: Colors.grey.shade700, height: 1.5),
          ),
        ],
      ),
    );
  }
}

/* ------------------------------------------------------ */
/* Episode Card                                           */
/* ------------------------------------------------------ */

class _EpisodeCard extends StatelessWidget {
  final Episode episode;
  final bool isCompleted;
  final bool unlocked;
  final VoidCallback onTap;

  const _EpisodeCard({
    required this.episode,
    required this.isCompleted,
    required this.unlocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isCompleted ? Colors.white : const Color(0xFFF1EBE5);

    final borderColor = isCompleted
        ? Colors.transparent
        : const Color(0xFFE7DBCF);

    return Opacity(
      opacity: unlocked ? 1 : 0.6,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: isCompleted ? 0 : 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              /// 🖼 Thumbnail
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 64,
                      height: 64,
                      color: Colors.grey.shade300,
                      child: isCompleted
                          ? Image.asset(
                              'assets/images/episode_placeholder.jpeg',
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              unlocked ? Icons.add_a_photo : Icons.lock,
                              color: const Color(0xFF9A734C),
                            ),
                    ),
                  ),

                  /// ✅ Check Badge
                  if (isCompleted)
                    Positioned(
                      top: -6,
                      left: -6,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEE8C2B),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 12),

              /// 📝 Text Area
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      episode.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      episode.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9A734C),
                      ),
                    ),
                  ],
                ),
              ),

              /// ⭐ Right Icon
              Icon(
                isCompleted ? Icons.stars : Icons.circle_outlined,
                color: isCompleted
                    ? const Color(0xFFEE8C2B)
                    : const Color(0xFF9A734C),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
