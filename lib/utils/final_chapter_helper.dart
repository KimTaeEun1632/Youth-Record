enum FinalChapterState { locked, almost, unlocked }

FinalChapterState getFinalChapterState(int completedEpCount) {
  if (completedEpCount >= 49) {
    return FinalChapterState.unlocked;
  } else if (completedEpCount == 48) {
    return FinalChapterState.almost;
  } else {
    return FinalChapterState.locked;
  }
}
