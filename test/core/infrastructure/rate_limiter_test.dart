import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/core/infrastructure/rate_limiter.dart';

void main() {
  late RateLimiter rateLimiter;

  setUp(() {
    rateLimiter = RateLimiter();
  });

  group('RateLimiter', () {
    test('allow should return true for first request', () {
      final result = rateLimiter.allow('test_key');
      expect(result, true);
    });

    test('allow should respect max token limit', () {
      for (var i = 0; i < 10; i++) {
        expect(rateLimiter.allow('limited', maxTokens: 10, refillRate: 100), true);
      }
      expect(rateLimiter.allow('limited', maxTokens: 10, refillRate: 100), false);
    });

    test('getRemainingTokens should return correct count', () {
      rateLimiter.allow('key', maxTokens: 5, refillRate: 100);
      expect(rateLimiter.getRemainingTokens('key'), 4);
    });

    test('getRemainingTokens should return 0 for unknown key', () {
      expect(rateLimiter.getRemainingTokens('unknown'), 0);
    });

    test('reset should clear tokens for a key', () {
      for (var i = 0; i < 5; i++) {
        rateLimiter.allow('key', maxTokens: 5, refillRate: 100);
      }
      expect(rateLimiter.allow('key', maxTokens: 5, refillRate: 100), false);
      rateLimiter.reset('key');
      expect(rateLimiter.allow('key', maxTokens: 5, refillRate: 100), true);
    });

    test('resetAll should clear all keys', () {
      rateLimiter.allow('key1', maxTokens: 1, refillRate: 100);
      rateLimiter.allow('key2', maxTokens: 1, refillRate: 100);
      expect(rateLimiter.allow('key1', maxTokens: 1, refillRate: 100), false);
      expect(rateLimiter.allow('key2', maxTokens: 1, refillRate: 100), false);
      rateLimiter.resetAll();
      expect(rateLimiter.allow('key1', maxTokens: 1, refillRate: 100), true);
      expect(rateLimiter.allow('key2', maxTokens: 1, refillRate: 100), true);
    });

    test('allowCustom should handle custom costs', () {
      expect(rateLimiter.allowCustom('key', cost: 3, maxTokens: 10, refillRate: 100), true);
      expect(rateLimiter.getRemainingTokens('key'), 7);
    });

    test('allowCustom should reject when cost exceeds tokens', () {
      expect(rateLimiter.allowCustom('key', cost: 10, maxTokens: 10, refillRate: 100), true);
      expect(rateLimiter.allowCustom('key', cost: 1, maxTokens: 10, refillRate: 100), false);
    });

    test('token refill should work over time', () async {
      rateLimiter.allow('key', maxTokens: 1, refillRate: 100);
      expect(rateLimiter.allow('key', maxTokens: 1, refillRate: 100), false);
      await Future.delayed(const Duration(milliseconds: 20));
      expect(rateLimiter.allow('key', maxTokens: 1, refillRate: 100), true);
    });
  });
}
