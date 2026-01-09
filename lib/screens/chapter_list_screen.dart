import 'package:flutter/material.dart';
import '../data/chapters.dart';
import '../models/chapter.dart';
import '../services/user_progress_service.dart';
import '../utils/chapter_progress_helper.dart';
import '../utils/final_chapter_helper.dart';
import 'episode_list_screen.dart';

class ChapterListScreen extends StatelessWidget {
  const ChapterListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F6),
      appBar: AppBar(
        title: const Text('청춘기록'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<int>(
        stream: UserProgressService.completedEpCountStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final completedEpCount = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            itemCount: chapters.length,
            itemBuilder: (context, index) {
              final chapter = chapters[index];

              // 🔥 Final Chapter
              if (chapter.isFinal) {
                final state = getFinalChapterState(completedEpCount);
                return _FinalChapterCard(
                  chapter: chapter,
                  state: state,
                  onTap: state == FinalChapterState.unlocked
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EpisodeListScreen(
                                chapterTitle: chapter.title,
                                startEp: chapter.startEp,
                                endEp: chapter.endEp,
                              ),
                            ),
                          );
                        }
                      : null,
                );
              }

              final completedInChapter = calculateCompletedInChapter(
                completedEpCount: completedEpCount,
                startEp: chapter.startEp,
                endEp: chapter.endEp,
              );

              final total = chapter.totalCount;
              final progress = completedInChapter / total;

              final ChapterCardState state = completedInChapter == total
                  ? ChapterCardState.completed
                  : ChapterCardState.inProgress;

              return _ChapterCard(
                chapter: chapter,
                state: state,
                completed: completedInChapter,
                total: total,
                progress: progress,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EpisodeListScreen(
                        chapterTitle: chapter.title,
                        startEp: chapter.startEp,
                        endEp: chapter.endEp,
                      ),
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

/* ------------------------------------------------------ */
/* Chapter Card                                           */
/* ------------------------------------------------------ */

enum ChapterCardState { inProgress, completed }

class _ChapterCard extends StatelessWidget {
  final Chapter chapter;
  final ChapterCardState state;
  final int completed;
  final int total;
  final double progress;
  final VoidCallback? onTap;

  const _ChapterCard({
    required this.chapter,
    required this.state,
    required this.completed,
    required this.total,
    required this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = state == ChapterCardState.completed;

    return Opacity(
      opacity: 1,
      child: Card(
        margin: const EdgeInsets.only(bottom: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 6,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🖼 Cover Image
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    child: Image.asset(
                      chapter.coverAssets,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      color: null,
                      colorBlendMode: null,
                    ),
                  ),

                  /// Status Badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: _StatusBadge(state: state),
                  ),

                  if (isCompleted)
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Transform.rotate(
                        angle: -0.1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xFFEE8C2B),
                              width: 3,
                            ),
                          ),
                          child: const Text(
                            'COMPLETE',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFEE8C2B),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 작은 Chapter Title
                    Text(
                      chapter.title.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: Color(0xFFEE8C2B),
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// Description (메인 타이틀)
                    Text(
                      chapter.description,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        color: Colors.black87,
                      ),
                    ),

                    if (state == ChapterCardState.inProgress) ...[
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Progress',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            '$completed / $total',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFEE8C2B),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(8),
                        backgroundColor: Colors.grey.shade300,
                        color: const Color(0xFFEE8C2B),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ------------------------------------------------------ */
/* Status Badge                                           */
/* ------------------------------------------------------ */

class _StatusBadge extends StatelessWidget {
  final ChapterCardState state;

  const _StatusBadge({required this.state});

  @override
  Widget build(BuildContext context) {
    final isCompleted = state == ChapterCardState.completed;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.black87 : const Color(0xFFEE8C2B),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isCompleted ? 'FINISHED' : 'NOW RECORDING',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

/* ------------------------------------------------------ */
/* Final Chapter Card (기존 유지)                          */
/* ------------------------------------------------------ */

class _FinalChapterCard extends StatelessWidget {
  final Chapter chapter;
  final FinalChapterState state;
  final VoidCallback? onTap;

  const _FinalChapterCard({
    required this.chapter,
    required this.state,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String message;
    IconData icon;

    switch (state) {
      case FinalChapterState.almost:
        message = '이제 한 페이지 남았어요';
        icon = Icons.auto_awesome;
        break;
      case FinalChapterState.unlocked:
        message = '이 이야기를 완성할 시간이에요';
        icon = Icons.star;
        break;
      default:
        message = '모든 이야기를 기록하면 열려요';
        icon = Icons.lock;
    }

    return Opacity(
      opacity: state == FinalChapterState.locked ? 0.4 : 1,
      child: Card(
        margin: const EdgeInsets.only(bottom: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Icon(icon, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    chapter.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(message, style: TextStyle(color: Colors.grey.shade700)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
