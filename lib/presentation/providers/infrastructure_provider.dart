import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/core/infrastructure/cache_manager.dart';
import 'package:game_show_app/core/infrastructure/connectivity_service.dart';
import 'package:game_show_app/core/infrastructure/feature_flag_service.dart';
import 'package:game_show_app/core/infrastructure/session_manager.dart';
import 'package:game_show_app/core/infrastructure/theme_service.dart';
import 'package:game_show_app/core/infrastructure/logging_service.dart';
import 'package:game_show_app/core/infrastructure/permission_handler.dart';
import 'package:game_show_app/core/infrastructure/analytics_helper.dart';
import 'package:game_show_app/core/infrastructure/rate_limiter.dart';
import 'package:game_show_app/core/infrastructure/retry_policy.dart';
import 'package:game_show_app/core/infrastructure/data_migration.dart';
import 'package:game_show_app/services/analytics/analytics_service.dart';

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});

final cacheProvider = Provider<CacheManager>((ref) {
  final cache = CacheManager();
  ref.onDispose(() => cache.clear());
  return cache;
});

final connectivityProvider = StreamProvider<bool>((ref) {
  final service = ConnectivityService();
  return service.onConnectivityChanged;
});

final connectivityStatusProvider = FutureProvider<bool>((ref) async {
  final service = ConnectivityService();
  return await service.isConnected();
});

final sessionProvider = Provider<SessionManager>((ref) {
  return SessionManager();
});

final featureFlagProvider = Provider<FeatureFlagService>((ref) {
  return FeatureFlagService();
});

final loggingServiceProvider = Provider<LoggingService>((ref) {
  return LoggingService();
});

final permissionHandlerProvider = Provider<PermissionHandler>((ref) {
  return PermissionHandler();
});

final analyticsHelperProvider = Provider<AnalyticsHelper>((ref) {
  final analyticsService = ref.read(analyticsServiceProvider);
  return AnalyticsHelper(analyticsService);
});

final rateLimiterProvider = Provider<RateLimiter>((ref) {
  return RateLimiter();
});

final retryPolicyProvider = Provider<RetryPolicy>((ref) {
  return const RetryPolicy();
});

final dataMigrationProvider = Provider<DataMigration>((ref) {
  final localStorage = ref.read(localStorageProvider);
  return DataMigration(localStorage);
});
