enum GameMode {
  classic,
  duel,
  speedrun,
  survival,
  bossBattle,
}

extension GameModeExtension on GameMode {
  String get nameAr {
    switch (this) {
      case GameMode.classic: return 'كلاسيك';
      case GameMode.duel: return 'مبارزة';
      case GameMode.speedrun: return 'سباق';
      case GameMode.survival: return 'بقاء';
      case GameMode.bossBattle: return 'تحدي الزعيم';
    }
  }

  String get description {
    switch (this) {
      case GameMode.classic: return 'الوضع التقليدي - أجب على الأسئلة واجمع النقاط';
      case GameMode.duel: return '1 ضد 1 في مبارزة معرفة';
      case GameMode.speedrun: return 'أسرع إجابة تفوز - 5 ثواني فقط للسؤال';
      case GameMode.survival: return '3 أخطاء وتنتهي اللعبة';
      case GameMode.bossBattle: return '10 أسئلة متتالية بشكل صحيح للتغلب على الزعيم';
    }
  }

  String get icon {
    switch (this) {
      case GameMode.classic: return '🎯';
      case GameMode.duel: return '🤺';
      case GameMode.speedrun: return '⚡';
      case GameMode.survival: return '❤️';
      case GameMode.bossBattle: return '🐉';
    }
  }

  bool get hasTimer => this == GameMode.speedrun;
  bool get isCompetitive => this == GameMode.duel;
  bool get isCooperative => false;
}

class GameModeConfig {
  final GameMode mode;
  final int questionCount;
  final int timePerQuestion;
  final int maxLives;
  final bool showScores;
  final bool shuffleQuestions;
  final bool allowPowerUps;

  const GameModeConfig({
    required this.mode,
    this.questionCount = 20,
    this.timePerQuestion = 30,
    this.maxLives = 3,
    this.showScores = true,
    this.shuffleQuestions = true,
    this.allowPowerUps = false,
  });

  static const Map<GameMode, GameModeConfig> defaults = {
    GameMode.classic: GameModeConfig(mode: GameMode.classic, questionCount: 20),
    GameMode.duel: GameModeConfig(mode: GameMode.duel, questionCount: 10, timePerQuestion: 10),
    GameMode.speedrun: GameModeConfig(mode: GameMode.speedrun, questionCount: 30, timePerQuestion: 5),
    GameMode.survival: GameModeConfig(mode: GameMode.survival, questionCount: 100, maxLives: 3),
    GameMode.bossBattle: GameModeConfig(mode: GameMode.bossBattle, questionCount: 10, maxLives: 1),
  };
}
