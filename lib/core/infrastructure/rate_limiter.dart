import 'dart:collection';
import 'package:game_show_app/core/utils/app_logger.dart';

class _TokenBucket {
  int _tokens;
  int _maxTokens;
  final double _refillRate;
  DateTime _lastRefill;

  _TokenBucket(this._tokens, this._maxTokens, this._refillRate, this._lastRefill);

  bool allow(int cost) {
    _refill();
    if (_tokens >= cost) {
      _tokens -= cost;
      return true;
    }
    return false;
  }

  void _refill() {
    final now = DateTime.now();
    final elapsed = now.difference(_lastRefill).inMilliseconds / 1000.0;
    final newTokens = (elapsed * _refillRate).floor();
    if (newTokens > 0) {
      _tokens = (_tokens + newTokens).clamp(0, _maxTokens);
      _lastRefill = now;
    }
  }

  int get remainingTokens => _tokens;

  void updateCapacity(int maxTokens) {
    _maxTokens = maxTokens;
    _tokens = _tokens.clamp(0, _maxTokens);
  }
}

class RateLimiter {
  final Map<String, _TokenBucket> _buckets = HashMap();

  bool allow(String key, {int maxTokens = 10, double refillRate = 1.0}) {
    final bucket = _buckets.putIfAbsent(
      key,
      () => _TokenBucket(maxTokens, maxTokens, refillRate, DateTime.now()),
    );
    final allowed = bucket.allow(1);
    if (!allowed) {
      AppLogger.warning('Rate limit exceeded for key: $key');
    }
    return allowed;
  }

  int getRemainingTokens(String key) {
    final bucket = _buckets[key];
    if (bucket == null) return 0;
    return bucket.remainingTokens;
  }

  void reset(String key) {
    _buckets.remove(key);
    AppLogger.debug('Rate limit reset for key: $key');
  }

  void resetAll() {
    _buckets.clear();
    AppLogger.debug('All rate limits reset');
  }

  bool allowCustom(String key, {required int cost, required int maxTokens, required double refillRate}) {
    final bucket = _buckets.putIfAbsent(
      key,
      () => _TokenBucket(maxTokens, maxTokens, refillRate, DateTime.now()),
    );
    final allowed = bucket.allow(cost);
    if (!allowed) {
      AppLogger.warning('Rate limit exceeded for key: $key, cost: $cost');
    }
    return allowed;
  }
}
