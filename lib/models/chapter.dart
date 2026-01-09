class Chapter {
  final String id;
  final String title;
  final String description;
  final String coverAssets;
  final int startEp;
  final int endEp;
  final bool isFinal;

  Chapter({
    required this.id,
    required this.title,
    required this.description,
    required this.coverAssets,
    required this.startEp,
    required this.endEp,
    this.isFinal = false,
  });

  int get totalCount => endEp - startEp + 1;
}
