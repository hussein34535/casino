class AccessibilityService {
  // Task 383: Digital minimalism mode
  bool minimalMode = false;
  // Task 384: Battery efficient mode
  bool batterySaver = false;

  void toggleMinimalMode() {
    minimalMode = !minimalMode;
  }

  void toggleBatterySaver() {
    batterySaver = !batterySaver;
  }

  // Color-blind friendly palette
  static const List<String> colorBlindPalettes = [
    'Default',
    'Protanopia (Red-Blind)',
    'Deuteranopia (Green-Blind)',
    'Tritanopia (Blue-Blind)',
    'High Contrast',
  ];

  // Font size options
  static const List<double> fontSizeOptions = [12, 14, 16, 18, 20, 24, 28, 32];

  // Reduced motion for accessibility
  bool reduceMotion = false;

  // High contrast mode
  bool highContrast = false;

  // Screen reader optimization
  bool screenReaderOptimized = false;

  static const Map<String, Map<String, String>> shortcuts = {
    'next_question': {'key': 'Space', 'description': 'السؤال التالي'},
    'correct_answer': {'key': 'C', 'description': 'إجابة صحيحة'},
    'wrong_answer': {'key': 'W', 'description': 'إجابة خاطئة'},
    'show_results': {'key': 'R', 'description': 'عرض النتائج'},
    'pause': {'key': 'P', 'description': 'إيقاف مؤقت'},
    'fullscreen': {'key': 'F', 'description': 'ملء الشاشة'},
  };
}

final accessibilityService = AccessibilityService();
