bool isEpUnlocked({
  required int userCompletedCount,
  required int requiredCompletedCount,
}) {
  return userCompletedCount >= requiredCompletedCount;
}
