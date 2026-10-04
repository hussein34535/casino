import 'package:game_show_app/core/utils/app_logger.dart';
import 'package:game_show_app/data/datasources/local/local_storage.dart';

class DataMigration {
  final LocalStorage _localStorage;
  static const String _versionKey = 'data_migration_version';

  DataMigration(this._localStorage);

  Future<int> getCurrentVersion() async {
    final version = await _localStorage.getInt(_versionKey);
    return version ?? 0;
  }

  Future<void> setCurrentVersion(int version) async {
    await _localStorage.saveInt(_versionKey, version);
    AppLogger.info('Data migration version set to: $version');
  }

  Future<void> migrateIfNeeded() async {
    final currentVersion = await getCurrentVersion();
    AppLogger.info('Current data migration version: $currentVersion');

    if (currentVersion < 1) {
      await _migrationV1();
    }
    if (currentVersion < 2) {
      await _migrationV2();
    }

    await setCurrentVersion(2);
    AppLogger.info('Data migration completed successfully');
  }

  Future<void> _migrationV1() async {
    AppLogger.info('Running migration V1: initial schema');
    await _localStorage.saveBool('migration_v1_completed', true);
    await _localStorage.saveString('schema_version', '1.0');
    AppLogger.info('Migration V1 completed: initial schema');
  }

  Future<void> _migrationV2() async {
    AppLogger.info('Running migration V2: add settings defaults');
    final currentTheme = await _localStorage.getThemeMode();
    if (currentTheme.isEmpty) {
      await _localStorage.setThemeMode('dark');
    }

    final currentLocale = await _localStorage.getLocale();
    if (currentLocale.isEmpty) {
      await _localStorage.setLocale('ar');
    }

    await _localStorage.saveBool('settings_notifications', true);
    await _localStorage.saveBool('settings_sound_fx', true);
    await _localStorage.saveString('settings_language', 'ar');
    await _localStorage.saveBool('migration_v2_completed', true);
    AppLogger.info('Migration V2 completed: add settings defaults');
  }

  Future<bool> needsMigration() async {
    final version = await getCurrentVersion();
    return version < 2;
  }
}
