int calculateCompletedInChapter({
  required int completedEpCount,
  required int startEp,
  required int endEp,
}) {
  final completed = completedEpCount - (startEp - 1);
  if (completed < 0) return 0;

  return completed.clamp(0, endEp - startEp + 1);
}
