import 'package:shared_preferences/shared_preferences.dart';

class FeatureFlags {
  static final Map<String, bool> _features = {
    'ai_questions': false,
    'voice_chat': false,
    'blockchain_nft': false,
    'battle_royale': true,
    'power_ups': true,
    'dark_mode': true,
    'multiplayer_online': true,
    'crypto_payments': false,
    'ar_mode': false,
    'vr_mode': false,
    'enterprise_sso': false,
    'analytics_dashboard': true,
    'daily_challenges': true,
    'ai_opponent': false,
    'live_streaming': false,
  };

  static bool isEnabled(String feature) => _features[feature] ?? false;

  static Future<void> setEnabled(String feature, bool enabled) async {
    _features[feature] = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('feature_$feature', enabled);
  }

  static Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in _features.keys) {
      final saved = prefs.getBool('feature_$key');
      if (saved != null) {
        _features[key] = saved;
      }
    }
  }

  static List<String> get allFeatures => _features.keys.toList();
  static List<String> get enabledFeatures => _features.entries.where((e) => e.value).map((e) => e.key).toList();
}

class ABTestService {
  static final Map<String, String> _experiments = {
    'home_layout': 'A', // A = grid, B = list
    'question_style': 'A', // A = card, B = fullscreen
    'scoring_system': 'A', // A = linear, B = exponential
    'timer_style': 'A', // A = countdown, B = progress bar
    'payment_flow': 'A', // A = in-app, B = web
  };

  static String getVariant(String experiment) => _experiments[experiment] ?? 'A';

  static Future<void> assignVariant(String experiment, String variant) async {
    _experiments[experiment] = variant;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ab_$experiment', variant);
  }

  static Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in _experiments.keys) {
      final saved = prefs.getString('ab_$key');
      if (saved != null) {
        _experiments[key] = saved;
      }
    }
  }

  static Map<String, String> get allExperiments => Map.from(_experiments);
}
