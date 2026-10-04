import 'dart:collection';
import 'package:game_show_app/core/utils/app_logger.dart';

class _CacheEntry<T> {
  final T value;
  final DateTime expiry;

  _CacheEntry(this.value, this.expiry);

  bool get isExpired => DateTime.now().isAfter(expiry);
}

class CacheManager {
  final Map<String, _CacheEntry> _cache = HashMap();

  T? get<T>(String key) {
    final entry = _cache[key];
    if (entry == null) return null;
    if (entry.isExpired) {
      _cache.remove(key);
      AppLogger.debug('Cache expired for key: $key');
      return null;
    }
    return entry.value as T;
  }

  void set<T>(String key, T value, {Duration? ttl}) {
    final expiry = DateTime.now().add(ttl ?? const Duration(minutes: 5));
    _cache[key] = _CacheEntry<T>(value, expiry);
    AppLogger.debug('Cache set for key: $key, expires at: $expiry');
  }

  void remove(String key) {
    _cache.remove(key);
    AppLogger.debug('Cache removed for key: $key');
  }

  void clear() {
    _cache.clear();
    AppLogger.debug('Cache cleared');
  }

  bool has(String key) {
    final entry = _cache[key];
    if (entry == null) return false;
    if (entry.isExpired) {
      _cache.remove(key);
      return false;
    }
    return true;
  }

  Future<T> getOrSet<T>(String key, {required Duration ttl, required Future<T> Function() fetcher}) async {
    final cached = get<T>(key);
    if (cached != null) return cached;

    final value = await fetcher();
    set<T>(key, value, ttl: ttl);
    return value;
  }

  void removeByPrefix(String prefix) {
    _cache.removeWhere((key, _) => key.startsWith(prefix));
    AppLogger.debug('Cache entries removed with prefix: $prefix');
  }

  int get size => _cache.length;

  void cleanExpired() {
    _cache.removeWhere((key, entry) {
      if (entry.isExpired) {
        AppLogger.debug('Cleaned expired cache entry: $key');
        return true;
      }
      return false;
    });
  }
}
