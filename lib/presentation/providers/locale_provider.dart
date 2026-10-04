import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/features/multi_language.dart';

final localeProvider =
    StateNotifierProvider<LocaleNotifier, XoLocale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<XoLocale> {
  LocaleNotifier() : super(const XoLocale('ar', 'Arabic', 'العربية', true));

  void setLocale(XoLocale locale) {
    state = locale;
  }

  void setLocaleFromCode(String code) {
    state = XoLocale.fromCode(code);
  }
}
