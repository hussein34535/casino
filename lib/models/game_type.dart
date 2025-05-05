// تعريف أنواع الألعاب الممكنة
enum GameType {
  trivia, // معلومات عامة
  movies, // أفلام ومسلسلات
  music, // مزيكا
  puzzles, // ألغاز وأحاجي
  words // ألعاب كلمات
}

// دالة للحصول على اسم النوع بالعربية (اختياري، للتوضيح)
String getGameTypeNameAr(GameType type) {
  switch (type) {
    case GameType.trivia:
      return 'معلومات عامة';
    case GameType.movies:
      return 'أفلام ومسلسلات';
    case GameType.music:
      return 'مزيكا';
    case GameType.puzzles:
      return 'ألغاز وأحاجي';
    case GameType.words:
      return 'كلمات معكوسه';
    default:
      return 'غير معروف';
  }
}
