class AppConstants {
  static const String appName = 'كازينو الألعاب';
  static const String appNameEn = 'Xo Game Show';

  // Game constants
  static const int maxPlayers = 10;
  static const int minPlayers = 1;
  static const int defaultRoundTime = 30;
  static const int maxQuestionsPerGame = 50;

  // SharedPreferences keys
  static const String prefsPlayerNamesKey = 'player_names';
  static const String prefsOnboardingDone = 'onboarding_done';
  static const String prefsThemeMode = 'theme_mode';
  static const String prefsLocaleKey = 'locale';

  // Firebase collections
  static const String usersCollection = 'users';
  static const String questionsCollection = 'questions';
  static const String gamesCollection = 'games';
  static const String leaderboardCollection = 'leaderboard';
  static const String achievementsCollection = 'achievements';
  static const String friendsCollection = 'friends';
  static const String notificationsCollection = 'notifications';

  // API endpoints
  static const String baseUrl = 'https://api.xo-game.com/v1';
  static const String socketUrl = 'wss://socket.xo-game.com';

  // Game types
  static const List<String> gameTypeNames = [
    'معلومات عامة',
    'أفلام ومسلسلات',
    'مزيكا',
    'ألغاز وأحاجي',
    'كلمات معكوسه',
  ];
}
