import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/features/multi_language.dart';
import 'package:game_show_app/presentation/providers/locale_provider.dart';

void main() {
  group('LocaleNotifier', () {
    test('initial locale is Arabic', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final locale = container.read(localeProvider);
      expect(locale.code, 'ar');
      expect(locale.name, 'Arabic');
    });

    test('setLocale changes locale', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(localeProvider.notifier);
      final english = XoLocale('en', 'English', 'English', false);
      notifier.setLocale(english);
      final locale = container.read(localeProvider);
      expect(locale.code, 'en');
      expect(locale.name, 'English');
    });

    test('setLocaleFromCode works for en', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(localeProvider.notifier);
      notifier.setLocaleFromCode('en');
      expect(container.read(localeProvider).code, 'en');
    });

    test('setLocaleFromCode works for fr', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(localeProvider.notifier);
      notifier.setLocaleFromCode('fr');
      expect(container.read(localeProvider).code, 'fr');
    });

    test('setLocaleFromCode falls back to ar for unknown codes', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(localeProvider.notifier);
      notifier.setLocaleFromCode('zz');
      final locale = container.read(localeProvider);
      expect(locale.code, 'ar');
      expect(locale.name, 'Arabic');
    });

    test('setLocaleFromCode falls back to ar for empty string', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(localeProvider.notifier);
      notifier.setLocaleFromCode('');
      expect(container.read(localeProvider).code, 'ar');
    });

    test('setLocale preserves isRtl property', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(localeProvider.notifier);
      notifier.setLocaleFromCode('en');
      expect(container.read(localeProvider).isRtl, false);
    });

    test('setLocaleFromCode works for fictional languages', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(localeProvider.notifier);
      notifier.setLocaleFromCode('tlh');
      expect(container.read(localeProvider).code, 'tlh');
    });
  });
}
