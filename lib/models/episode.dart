class Episode {
  final String id;
  final int episodeNumber;
  final String title;
  final String description;
  final String category;
  final bool isSpecial;
  final int requiredCompletedCount;

  Episode({
    required this.id,
    required this.episodeNumber,
    required this.title,
    required this.description,
    required this.category,
    required this.isSpecial,
    required this.requiredCompletedCount,
  });
  factory Episode.fromFirestore(String id, Map<String, dynamic> data) {
    return Episode(
      id: id,
      episodeNumber: data['episodeNumber'] ?? 0,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      isSpecial: data['isSpecial'] ?? false,
      requiredCompletedCount: data['requiredCompletedCount'] ?? 0,
    );
  }
}
