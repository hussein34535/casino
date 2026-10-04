import 'dart:ui';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:game_show_app/core/infrastructure/data_migration.dart';
import 'package:game_show_app/core/infrastructure/theme_service.dart';
import 'package:game_show_app/core/theme/app_theme.dart';
import 'package:game_show_app/data/datasources/local/local_storage.dart';
import 'package:game_show_app/l10n/app_localizations.dart';
import 'package:game_show_app/presentation/providers/locale_provider.dart';
import 'package:game_show_app/presentation/providers/keyboard_shortcut_provider.dart';
import 'package:game_show_app/features/multi_language.dart';
import 'package:game_show_app/presentation/providers/notification_provider.dart';
import 'package:game_show_app/router/app_router.dart';
import 'package:game_show_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final localStorage = LocalStorage();
  await localStorage.init();
  await DataMigration(localStorage).migrateIfNeeded();

  if (!kIsWeb) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
  }
  PlatformDispatcher.instance.onError = (error, stack) {
    if (!kIsWeb) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    }
    return true;
  };

  runApp(const ProviderScope(child: XoApp()));
}

class XoApp extends ConsumerWidget {
  const XoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);
    
    // Initialize notifications
    ref.watch(notificationInitializerProvider);

    return KeyboardShortcutHandler(
      child: MaterialApp.router(
        title: 'إكس أو',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        routerConfig: router,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          AppLocalizations.delegate,
        ],
        supportedLocales: XoLocale.supportedLocales
            .where((l) => ['ar', 'en', 'fr'].contains(l.code))
            .map((l) => Locale(l.code, ''))
            .toList(),
        localeResolutionCallback: (locale, supportedLocales) {
          if (locale == null) return const Locale('ar');
          for (final supported in supportedLocales) {
            if (supported.languageCode == locale.languageCode) {
              return supported;
            }
          }
          return const Locale('ar');
        },
        locale: Locale(locale.code),
        debugShowCheckedModeBanner: false,
        builder: (context, child) => child!,
      ),
    );
  }
}
