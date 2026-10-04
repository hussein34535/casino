class XoLocale {
  final String code;
  final String name;
  final String nativeName;
  final bool isRtl;

  const XoLocale(this.code, this.name, this.nativeName, this.isRtl);

  static const List<XoLocale> supportedLocales = [
    XoLocale('ar', 'Arabic', 'العربية', true),
    XoLocale('en', 'English', 'English', false),
    XoLocale('fr', 'French', 'Français', false),
    XoLocale('es', 'Spanish', 'Español', false),
    XoLocale('de', 'German', 'Deutsch', false),
    XoLocale('zh', 'Chinese', '中文', false),
    XoLocale('ja', 'Japanese', '日本語', false),
    XoLocale('ko', 'Korean', '한국어', false),
    XoLocale('hi', 'Hindi', 'हिन्दी', false),
    XoLocale('tr', 'Turkish', 'Türkçe', false),
    XoLocale('ur', 'Urdu', 'اردو', true),
    XoLocale('fa', 'Persian', 'فارسی', true),
    XoLocale('ru', 'Russian', 'Русский', false),
    XoLocale('pt', 'Portuguese', 'Português', false),
    XoLocale('it', 'Italian', 'Italiano', false),
    // Fictional languages for Task 286
    XoLocale('tlh', 'Klingon', 'tlhIngan Hol', false),
    XoLocale('sjn', 'Sindarin (Elvish)', 'Sindarin', false),
    XoLocale('qya', 'Quenya (Elvish)', 'Quenya', false),
    XoLocale('doth', 'Dothraki', 'Dothraki', false),
    XoLocale('val', 'Valyrian', 'Valyrio', false),
    XoLocale('navi', 'Na\'vi', 'Na\'vi', false),
    XoLocale('minc', 'Minecraft Enchantment', ' enchantment', false),
    XoLocale('emoj', 'Emoji', '🔤➡️😊', false),
  ];

  static XoLocale fromCode(String code) {
    return supportedLocales.firstWhere(
      (l) => l.code == code,
      orElse: () => supportedLocales.first,
    );
  }
}

class LocalizedStrings {
  static const Map<String, Map<String, String>> _strings = {
    'app_name': {
      'ar': 'كازينو الألعاب',
      'en': 'XO Game Show',
      'fr': 'XO Jeu Télévisé',
      'es': 'XO Programa de Juegos',
      'de': 'XO Gameshow',
      'zh': 'XO游戏秀',
      'ja': 'XOゲームショー',
      'ko': 'XO 게임 쇼',
      'tlh': 'XO ',
      'emoj': '🎮🎪📺',
    },
    'start_game': {
      'ar': 'ابدأ اللعبة',
      'en': 'Start Game',
      'fr': 'Commencer le jeu',
      'es': 'Comenzar juego',
      'de': 'Spiel starten',
      'emoj': '▶️🎮',
    },
    'winner': {
      'ar': 'الفائز',
      'en': 'Winner',
      'fr': 'Gagnant',
      'es': 'Ganador',
      'de': 'Gewinner',
      'emoj': '🏆😊',
    },
    'correct_answer': {
      'ar': 'إجابة صحيحة!',
      'en': 'Correct!',
      'fr': 'Correct!',
      'es': '¡Correcto!',
      'de': 'Richtig!',
      'emoj': '✅🎉',
    },
    'wrong_answer': {
      'ar': 'إجابة خاطئة!',
      'en': 'Wrong!',
      'fr': 'Faux!',
      'es': '¡Incorrecto!',
      'de': 'Falsch!',
      'emoj': '❌😢',
    },
    'time_up': {
      'ar': 'انتهى الوقت!',
      'en': 'Time\'s up!',
      'fr': 'Temps écoulé!',
      'es': '¡Se acabó el tiempo!',
      'de': 'Zeit abgelaufen!',
      'emoj': '⏰❌',
    },
  };

  static String get(String key, String locale) {
    return _strings[key]?[locale] ?? _strings[key]?['en'] ?? key;
  }

  static String tr(String key, String locale) => get(key, locale);
}
