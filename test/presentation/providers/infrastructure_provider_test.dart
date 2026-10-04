import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/core/infrastructure/cache_manager.dart';
import 'package:game_show_app/core/infrastructure/feature_flag_service.dart';
import 'package:game_show_app/core/infrastructure/rate_limiter.dart';
import 'package:game_show_app/core/infrastructure/retry_policy.dart';
import 'package:game_show_app/presentation/providers/infrastructure_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Infrastructure Providers', () {
    group('cacheProvider', () {
      test('provides a CacheManager instance', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        expect(container.read(cacheProvider), isA<CacheManager>());
      });

      test('returns the same instance on repeated reads', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final cache1 = container.read(cacheProvider);
        final cache2 = container.read(cacheProvider);
        expect(identical(cache1, cache2), isTrue);
      });

      test('supports basic cache operations', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final cache = container.read(cacheProvider);
        cache.set('key', 'value');
        expect(cache.get('key'), 'value');
        cache.remove('key');
        expect(cache.get('key'), isNull);
      });
    });

    group('rateLimiterProvider', () {
      test('provides a RateLimiter instance', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        expect(container.read(rateLimiterProvider), isA<RateLimiter>());
      });

      test('returns the same instance on repeated reads', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final rl1 = container.read(rateLimiterProvider);
        final rl2 = container.read(rateLimiterProvider);
        expect(identical(rl1, rl2), isTrue);
      });

      test('allows first request with default tokens', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final rateLimiter = container.read(rateLimiterProvider);
        expect(rateLimiter.allow('test_key'), isTrue);
      });
    });

    group('retryPolicyProvider', () {
      test('provides a RetryPolicy instance with default values', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final policy = container.read(retryPolicyProvider);
        expect(policy, isA<RetryPolicy>());
        expect(policy.maxRetries, 3);
        expect(policy.baseDelay, const Duration(seconds: 1));
        expect(policy.multiplier, 2.0);
      });

      test('returns const instance', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final policy = container.read(retryPolicyProvider);
        expect(policy, const RetryPolicy());
      });
    });

    group('featureFlagProvider', () {
      test('provides a FeatureFlagService instance', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        expect(container.read(featureFlagProvider), isA<FeatureFlagService>());
      });

      test('returns false for unknown flags', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final service = container.read(featureFlagProvider);
        expect(service.isEnabled('nonexistent_flag'), isFalse);
      });

      test('isExperimental returns true for known experimental flags', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final service = container.read(featureFlagProvider);
        expect(service.isExperimental('ai_questions'), isTrue);
        expect(service.isExperimental('voice_chat'), isTrue);
      });

      test('isExperimental returns false for non-experimental flags', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final service = container.read(featureFlagProvider);
        expect(service.isExperimental('battle_royale'), isFalse);
        expect(service.isExperimental('dark_mode'), isFalse);
      });
    });

    group('connectivityProvider', () {
      test('is a StreamProvider returning AsyncValue<bool>', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final state = container.read(connectivityProvider);
        expect(state, isA<AsyncValue<bool>>());
      });

      test('initial state is loading', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final state = container.read(connectivityProvider);
        expect(state.isLoading, isTrue);
      });
    });
  });
}
