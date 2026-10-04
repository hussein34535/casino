import 'package:game_show_app/core/utils/app_logger.dart';
import 'package:game_show_app/features/feature_flags.dart';

class FeatureFlagService {
  final Map<String, bool> _cachedFlags = {};

  bool isEnabled(String flag) {
    if (_cachedFlags.containsKey(flag)) {
      return _cachedFlags[flag]!;
    }
    final value = FeatureFlags.isEnabled(flag);
    _cachedFlags[flag] = value;
    return value;
  }

  Future<void> setEnabled(String flag, bool value) async {
    await FeatureFlags.setEnabled(flag, value);
    _cachedFlags[flag] = value;
    AppLogger.info('Feature flag "$flag" set to $value');
  }

  List<String> getEnabledFlags() {
    final cached = _cachedFlags.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();
    if (cached.isNotEmpty) return cached;

    final enabled = FeatureFlags.enabledFeatures;
    for (final flag in enabled) {
      _cachedFlags[flag] = true;
    }
    return enabled;
  }

  List<String> getAllFlags() {
    return FeatureFlags.allFeatures;
  }

  Future<void> refreshFlags() async {
    await FeatureFlags.loadFromPrefs();
    _cachedFlags.clear();
    AppLogger.info('Feature flags refreshed from prefs');
  }

  bool isExperimental(String flag) {
    const experimentalFlags = [
      'ai_questions',
      'voice_chat',
      'blockchain_nft',
      'crypto_payments',
      'ar_mode',
      'vr_mode',
      'enterprise_sso',
      'ai_opponent',
      'live_streaming',
    ];
    return experimentalFlags.contains(flag);
  }

  String? getExperimentVariant(String experiment) {
    return ABTestService.getVariant(experiment);
  }

  Future<void> setExperimentVariant(String experiment, String variant) async {
    await ABTestService.assignVariant(experiment, variant);
    AppLogger.info('Experiment "$experiment" variant set to $variant');
  }

  Map<String, String> getAllExperiments() {
    return ABTestService.allExperiments;
  }
}
