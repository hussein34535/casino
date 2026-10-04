import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/core/utils/app_logger.dart';
import 'package:game_show_app/data/datasources/local/local_storage.dart';

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final LocalStorage _localStorage;

  ThemeModeNotifier(this._localStorage) : super(ThemeMode.dark) {
    _loadSavedTheme();
  }

  Future<void> _loadSavedTheme() async {
    final mode = await _localStorage.getThemeMode();
    switch (mode) {
      case 'light':
        state = ThemeMode.light;
      case 'dark':
        state = ThemeMode.dark;
      case 'system':
        state = ThemeMode.system;
    }
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
    String modeStr;
    switch (mode) {
      case ThemeMode.light:
        modeStr = 'light';
      case ThemeMode.dark:
        modeStr = 'dark';
      case ThemeMode.system:
        modeStr = 'system';
    }
    _localStorage.setThemeMode(modeStr);
    AppLogger.info('Theme mode set to: $modeStr');
  }

  void toggleTheme() {
    switch (state) {
      case ThemeMode.dark:
        setThemeMode(ThemeMode.light);
      case ThemeMode.light:
        setThemeMode(ThemeMode.system);
      case ThemeMode.system:
        setThemeMode(ThemeMode.dark);
    }
  }

  bool get isDarkMode => state == ThemeMode.dark;
  bool get isLightMode => state == ThemeMode.light;
}

final localStorageProvider = Provider<LocalStorage>((ref) => LocalStorage());

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final localStorage = ref.read(localStorageProvider);
  return ThemeModeNotifier(localStorage);
});
