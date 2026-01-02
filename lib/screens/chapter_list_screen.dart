import 'package:flutter/material.dart';
import '../data/chapters.dart';
import '../services/user_progress_service.dart';
import '../utils/chapter_progress_helper.dart';
import 'episode_list_screen.dart';
import '../utils/final_chapter_helper.dart';
import '../models/chapter.dart';

class ChapterListScreen extends StatelessWidget {
  const ChapterListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('청춘기록')),
      body: StreamBuilder<int>(
        stream: UserProgressService.completedEpCountStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final completedEpCount = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: chapters.length,
            itemBuilder: (context, index) {
              final chapter = chapters[index];

              final completedInChapter = calculateCompletedInChapter(
                completedEpCount: completedEpCount,
                startEp: chapter.startEp,
                endEp: chapter.endEp,
              );

              final progress = completedInChapter / chapter.totalCount;

              final isFinal = chapter.isFinal;
              FinalChapterState? finalState;

              if (isFinal) {
                finalState = getFinalChapterState(completedEpCount);
              }

              if (chapter.isFinal) {
                return _FinalChapterCard(
                  chapter: chapter,
                  state: finalState!,
                  onTap: finalState == FinalChapterState.unlocked
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

              return Opacity(
                opacity: 1,
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
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
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  chapter.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(8),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            '$completedInChapter / ${chapter.totalCount} 완료',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

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
        color: state == FinalChapterState.unlocked
            ? Colors.amber.shade50
            : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.only(bottom: 20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                  ],
                ),

                const SizedBox(height: 12),

                Text(
                  message,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
