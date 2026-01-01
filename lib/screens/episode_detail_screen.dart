import 'package:flutter/material.dart';
import '../models/episode.dart';

class EpisodeDetailScreen extends StatelessWidget {
  final Episode episode;

  const EpisodeDetailScreen({super.key, required this.episode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('EP.${episode.episodeNumber}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목
            Text(
              episode.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            // 설명
            Text(episode.description, style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 24),

            // 카테고리
            Chip(label: Text(episode.category)),

            const SizedBox(height: 32),

            // 사진 영역
            const Text(
              '사진 기록 (최대 4장)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            _PhotoGrid(),

            const SizedBox(height: 40),

            // 완료 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 🔜 다음 단계: EP 완료 처리
                },
                child: const Text('이 에피소드 완료하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Icon(Icons.add_a_photo, color: Colors.grey, size: 32),
          ),
        );
      },
    );
  }
}
