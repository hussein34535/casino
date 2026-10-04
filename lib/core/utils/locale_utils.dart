import 'package:flutter/material.dart';
import 'package:game_show_app/features/multi_language.dart';

class LocaleUtils {
  static const List<String> rtlLocales = ['ar', 'ur', 'fa'];

  static bool isRtl(String code) => rtlLocales.contains(code);

  static bool isSupported(String code) =>
      XoLocale.supportedLocales.any((l) => l.code == code);

  static XoLocale findLocale(String code) => XoLocale.fromCode(code);

  static String localeName(String code) {
    final locale = findLocale(code);
    return '${locale.nativeName} (${locale.name})';
  }

  static String flagEmoji(String code) {
    switch (code) {
      case 'ar':
        return '\u{1F1E6}\u{1F1F7}';
      case 'en':
        return '\u{1F1EC}\u{1F1E7}';
      case 'fr':
        return '\u{1F1EB}\u{1F1F7}';
      case 'es':
        return '\u{1F1EA}\u{1F1F8}';
      case 'de':
        return '\u{1F1E9}\u{1F1EA}';
      case 'zh':
        return '\u{1F1E8}\u{1F1F3}';
      case 'ja':
        return '\u{1F1EF}\u{1F1F5}';
      case 'ko':
        return '\u{1F1F0}\u{1F1F7}';
      case 'hi':
        return '\u{1F1EE}\u{1F1F3}';
      case 'tr':
        return '\u{1F1F9}\u{1F1F7}';
      case 'ur':
        return '\u{1F1F5}\u{1F1F0}';
      case 'fa':
        return '\u{1F1EE}\u{1F1F1}';
      case 'ru':
        return '\u{1F1F7}\u{1F1FA}';
      case 'pt':
        return '\u{1F1E7}\u{1F1F7}';
      case 'it':
        return '\u{1F1EE}\u{1F1F9}';
      default:
        return '\u{1F310}';
    }
  }

  static List<Locale> get flutterLocales =>
      XoLocale.supportedLocales.map((l) => Locale(l.code)).toList();
}
