import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/l10n/app_localizations.dart';
import 'package:game_show_app/presentation/providers/localization_provider.dart';
import 'package:game_show_app/presentation/providers/locale_provider.dart';
import 'package:game_show_app/features/multi_language.dart';

void main() {
  group('LocalizationProvider', () {
    test('localizationProvider returns AppLocalizations with Arabic locale by default', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final localizations = container.read(localizationProvider);
      expect(localizations, isA<AppLocalizations>());
      expect(localizations.localeCode, 'ar');
    });

    test('localizationProvider updates when locale changes', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final localizations = container.read(localizationProvider);
      expect(localizations.localeCode, 'ar');

      container.read(localeProvider.notifier).setLocaleFromCode('en');
      final updated = container.read(localizationProvider);
      expect(updated.localeCode, 'en');
    });

    test('localizationProvider handles French locale', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(localeProvider.notifier).setLocale(XoLocale.fromCode('fr'));
      final localizations = container.read(localizationProvider);
      expect(localizations.localeCode, 'fr');
    });
  });
}
