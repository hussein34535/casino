class CheckStreak {
  int call({
    required DateTime lastActiveAt,
    required int streak,
  }) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final today = DateTime(now.year, now.month, now.day);
    final lastActiveDate = DateTime(lastActiveAt.year, lastActiveAt.month, lastActiveAt.day);

    if (lastActiveDate == yesterday) {
      return streak + 1;
    } else if (lastActiveDate == today) {
      return streak;
    } else {
      return 0;
    }
  }
}
