import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/l10n/app_localizations.dart';
import 'package:game_show_app/presentation/providers/locale_provider.dart';

final localizationProvider = Provider<AppLocalizations>((ref) {
  final locale = ref.watch(localeProvider);
  return AppLocalizations(locale.code);
});
