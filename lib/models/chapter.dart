class Chapter {
  final String id;
  final String title;
  final int startEp;
  final int endEp;
  final bool isFinal;

  Chapter({
    required this.id,
    required this.title,
    required this.startEp,
    required this.endEp,
    this.isFinal = false,
  });

  int get totalCount => endEp - startEp + 1;
}
