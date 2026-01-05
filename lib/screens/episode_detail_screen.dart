import 'package:flutter/material.dart';
import '../models/episode.dart';
import '../services/user_progress_service.dart';

class EpisodeDetailScreen extends StatefulWidget {
  final Episode episode;

  const EpisodeDetailScreen({super.key, required this.episode});

  @override
  State<EpisodeDetailScreen> createState() => _EpisodeDetailScreenState();
}

class _EpisodeDetailScreenState extends State<EpisodeDetailScreen> {
  final TextEditingController _noteController = TextEditingController();

  bool _isLoading = true;
  bool _isCompleted = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadRecord();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadRecord() async {
    final note = await UserProgressService.getEpisodeNote(
      widget.episode.episodeNumber,
    );

    if (note != null) {
      _noteController.text = note;
      _isCompleted = true;
    }

    setState(() => _isLoading = false);
  }

  Future<void> _completeEpisode() async {
    if (_noteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('한 줄 기록을 남겨주세요 ✍️')));
      return;
    }

    setState(() => _isSubmitting = true);

    await UserProgressService.completeEpisode(
      episodeNumber: widget.episode.episodeNumber,
      note: _noteController.text.trim(),
    );

    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> _updateEpisode() async {
    if (_noteController.text.trim().isEmpty) return;

    setState(() => _isSubmitting = true);

    await UserProgressService.updateEpisodeNote(
      episodeNumber: widget.episode.episodeNumber,
      note: _noteController.text.trim(),
    );

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final episode = widget.episode;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text('EP.${episode.episodeNumber}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              episode.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(episode.description),
            const SizedBox(height: 20),
            Chip(label: Text(episode.category)),
            const SizedBox(height: 32),

            const Text(
              '한 줄 기록',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: _noteController,
              maxLength: 50,
              decoration: const InputDecoration(
                hintText: '이 순간을 한 줄로 남겨보세요',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting
                    ? null
                    : _isCompleted
                    ? _updateEpisode
                    : _completeEpisode,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(_isCompleted ? '기록 수정하기' : '이 에피소드 완료하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
