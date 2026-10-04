enum GameType {
  trivia,
  movies,
  music,
  puzzles,
  words;

  String get nameAr {
    switch (this) {
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
    }
  }

  String get nameEn {
    switch (this) {
      case GameType.trivia:
        return 'General Knowledge';
      case GameType.movies:
        return 'Movies & Series';
      case GameType.music:
        return 'Music';
      case GameType.puzzles:
        return 'Puzzles';
      case GameType.words:
        return 'Reversed Words';
    }
  }
}

String getGameTypeNameAr(GameType type) => type.nameAr;
