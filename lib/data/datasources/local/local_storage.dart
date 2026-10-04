import 'package:shared_preferences/shared_preferences.dart';
import 'package:game_show_app/core/constants/app_constants.dart';

class LocalStorage {
  SharedPreferences? _prefs;
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  Future<void> _ensureInit() async {
    if (!_initialized) await init();
  }

  SharedPreferences get _requirePrefs {
    assert(_prefs != null, 'LocalStorage not initialized. Call init() first.');
    return _prefs!;
  }

  // Player names
  Future<void> savePlayerNames(List<String> names) async {
    await _ensureInit();
    await _requirePrefs.setStringList(AppConstants.prefsPlayerNamesKey, names);
  }

  Future<List<String>?> getPlayerNames() async {
    await _ensureInit();
    return _requirePrefs.getStringList(AppConstants.prefsPlayerNamesKey);
  }

  // Onboarding
  Future<void> setOnboardingDone(bool done) async {
    await _ensureInit();
    await _requirePrefs.setBool(AppConstants.prefsOnboardingDone, done);
  }

  Future<bool> isOnboardingDone() async {
    await _ensureInit();
    return _requirePrefs.getBool(AppConstants.prefsOnboardingDone) ?? false;
  }

  // Theme mode
  Future<void> setThemeMode(String mode) async {
    await _ensureInit();
    await _requirePrefs.setString(AppConstants.prefsThemeMode, mode);
  }

  Future<String> getThemeMode() async {
    await _ensureInit();
    return _requirePrefs.getString(AppConstants.prefsThemeMode) ?? 'dark';
  }

  // Locale
  Future<void> setLocale(String locale) async {
    await _ensureInit();
    await _requirePrefs.setString(AppConstants.prefsLocaleKey, locale);
  }

  Future<String> getLocale() async {
    await _ensureInit();
    return _requirePrefs.getString(AppConstants.prefsLocaleKey) ?? 'ar';
  }

  // Generic methods
  Future<void> saveString(String key, String value) async {
    await _ensureInit();
    await _requirePrefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    await _ensureInit();
    return _requirePrefs.getString(key);
  }

  Future<void> saveInt(String key, int value) async {
    await _ensureInit();
    await _requirePrefs.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    await _ensureInit();
    return _requirePrefs.getInt(key);
  }

  Future<void> saveBool(String key, bool value) async {
    await _ensureInit();
    await _requirePrefs.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    await _ensureInit();
    return _requirePrefs.getBool(key);
  }

  Future<void> remove(String key) async {
    await _ensureInit();
    await _requirePrefs.remove(key);
  }

  Future<void> clear() async {
    await _ensureInit();
    await _requirePrefs.clear();
  }
}