import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/core/infrastructure/cache_manager.dart';

void main() {
  late CacheManager cacheManager;

  setUp(() {
    cacheManager = CacheManager();
  });

  group('CacheManager', () {
    test('set and get should store and retrieve values', () {
      cacheManager.set('name', 'Flutter');
      expect(cacheManager.get<String>('name'), 'Flutter');
    });

    test('get should return null for non-existent key', () {
      expect(cacheManager.get<String>('unknown'), isNull);
    });

    test('get should preserve type', () {
      cacheManager.set('count', 42);
      cacheManager.set('pi', 3.14);
      cacheManager.set('flag', true);
      expect(cacheManager.get<int>('count'), 42);
      expect(cacheManager.get<double>('pi'), 3.14);
      expect(cacheManager.get<bool>('flag'), true);
    });

    test('TTL expiry should return null', () async {
      cacheManager.set('temp', 'value', ttl: const Duration(milliseconds: 10));
      await Future.delayed(const Duration(milliseconds: 20));
      expect(cacheManager.get<String>('temp'), isNull);
    });

    test('should not expire before TTL', () async {
      cacheManager.set('temp', 'value', ttl: const Duration(seconds: 60));
      await Future.delayed(const Duration(milliseconds: 10));
      expect(cacheManager.get<String>('temp'), 'value');
    });

    test('remove should delete a key', () {
      cacheManager.set('key', 'value');
      cacheManager.remove('key');
      expect(cacheManager.get<String>('key'), isNull);
    });

    test('clear should remove all keys', () {
      cacheManager.set('a', 1);
      cacheManager.set('b', 2);
      cacheManager.clear();
      expect(cacheManager.get<int>('a'), isNull);
      expect(cacheManager.get<int>('b'), isNull);
    });

    test('getOrSet should fetch and cache value', () async {
      var callCount = 0;
      final result = await cacheManager.getOrSet<int>('key', ttl: const Duration(minutes: 5), fetcher: () async {
        callCount++;
        return 42;
      });
      expect(result, 42);
      expect(callCount, 1);

      final cached = await cacheManager.getOrSet<int>('key', ttl: const Duration(minutes: 5), fetcher: () async {
        callCount++;
        return 99;
      });
      expect(cached, 42);
      expect(callCount, 1);
    });

    test('getOrSet should re-fetch after expiry', () async {
      var callCount = 0;
      await cacheManager.getOrSet<int>('key', ttl: const Duration(milliseconds: 10), fetcher: () async {
        callCount++;
        return 42;
      });
      await Future.delayed(const Duration(milliseconds: 20));
      await cacheManager.getOrSet<int>('key', ttl: const Duration(milliseconds: 10), fetcher: () async {
        callCount++;
        return 99;
      });
      expect(callCount, 2);
    });

    test('has should return true for existing key', () {
      cacheManager.set('key', 'value');
      expect(cacheManager.has('key'), true);
    });

    test('has should return false for non-existent key', () {
      expect(cacheManager.has('unknown'), false);
    });

    test('has should return false after TTL expiry', () async {
      cacheManager.set('key', 'value', ttl: const Duration(milliseconds: 10));
      await Future.delayed(const Duration(milliseconds: 20));
      expect(cacheManager.has('key'), false);
    });

    test('has should return true before TTL expiry', () async {
      cacheManager.set('key', 'value', ttl: const Duration(seconds: 60));
      expect(cacheManager.has('key'), true);
    });

    test('size should track number of cached entries', () {
      expect(cacheManager.size, 0);
      cacheManager.set('a', 1);
      cacheManager.set('b', 2);
      expect(cacheManager.size, 2);
      cacheManager.remove('a');
      expect(cacheManager.size, 1);
    });

    test('removeByPrefix should remove matching keys', () {
      cacheManager.set('user:1', 'Alice');
      cacheManager.set('user:2', 'Bob');
      cacheManager.set('game:1', 'Trivia');
      cacheManager.removeByPrefix('user:');
      expect(cacheManager.has('user:1'), false);
      expect(cacheManager.has('user:2'), false);
      expect(cacheManager.has('game:1'), true);
    });

    test('cleanExpired should remove only expired entries', () async {
      cacheManager.set('permanent', 'value', ttl: const Duration(seconds: 60));
      cacheManager.set('temporary', 'value', ttl: const Duration(milliseconds: 10));
      await Future.delayed(const Duration(milliseconds: 20));
      cacheManager.cleanExpired();
      expect(cacheManager.has('permanent'), true);
      expect(cacheManager.has('temporary'), false);
    });
  });
}
