import 'package:flutter/material.dart';
import '../data/chapters.dart';
import '../services/user_progress_service.dart';
import '../utils/chapter_progress_helper.dart';
import 'episode_list_screen.dart';

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

              final isLocked = chapter.isFinal && completedEpCount < 49;

              return Opacity(
                opacity: isLocked ? 0.4 : 1,
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: isLocked
                        ? null
                        : () {
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
                              if (isLocked) const Icon(Icons.lock),
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
