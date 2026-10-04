import 'package:flutter/material.dart';
import 'package:game_show_app/features/multi_language.dart';

class LocalizationService {
  final String currentLocale;

  LocalizationService({this.currentLocale = 'ar'});

  List<XoLocale> get supportedLocales => XoLocale.supportedLocales;

  bool isRtl(String locale) =>
      locale == 'ar' || locale == 'ur' || locale == 'fa';

  XoLocale get currentXoLocale => XoLocale.fromCode(currentLocale);

  String translate(String key) => LocalizedStrings.get(key, currentLocale);

  String tr(String key) => translate(key);

  List<Locale> get flutterLocales =>
      supportedLocales.map((l) => Locale(l.code)).toList();

  Locale get flutterLocale => Locale(currentLocale);

  bool isSupported(String code) =>
      supportedLocales.any((l) => l.code == code);

  String get appName => translate('app_name');
  String get startGame => translate('start_game');
  String get winner => translate('winner');
  String get correctAnswer => translate('correct_answer');
  String get wrongAnswer => translate('wrong_answer');
  String get timeUp => translate('time_up');
}
