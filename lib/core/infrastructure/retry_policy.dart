import 'dart:async';
import 'dart:math';
import 'package:game_show_app/core/utils/app_logger.dart';

class RetryPolicy {
  final int maxRetries;
  final Duration baseDelay;
  final double multiplier;

  const RetryPolicy({
    this.maxRetries = 3,
    this.baseDelay = const Duration(seconds: 1),
    this.multiplier = 2.0,
  });

  bool canRetry(int attempt, Object? lastError) {
    if (lastError == null) return false;
    if (attempt > maxRetries) return false;
    if (lastError is FormatException) return false;
    if (lastError is ArgumentError) return false;
    return true;
  }

  Duration getDelay(int attempt) {
    final delayMs = baseDelay.inMilliseconds * pow(multiplier, attempt).toInt();
    final jitter = Random().nextInt(100);
    return Duration(milliseconds: delayMs + jitter);
  }

  Future<T> execute<T>(Future<T> Function() action, {int? maxRetries, Duration? baseDelay}) async {
    final retries = maxRetries ?? this.maxRetries;
    final delay = baseDelay ?? this.baseDelay;
    int attempt = 0;

    while (attempt <= retries) {
      try {
        return await action();
      } catch (e) {
        attempt++;
        if (!canRetry(attempt, e)) {
          AppLogger.error('Retry policy: non-retryable error', e);
          rethrow;
        }
        if (attempt > retries) {
          AppLogger.error('Retry policy: all $retries attempts failed', e);
          rethrow;
        }
        final waitDuration = Duration(
          milliseconds: delay.inMilliseconds * pow(multiplier, attempt - 1).toInt() +
              Random().nextInt(100),
        );
        AppLogger.warning('Retry attempt $attempt/$retries failed, retrying in ${waitDuration.inMilliseconds}ms');
        await Future.delayed(waitDuration);
      }
    }

    throw StateError('Unreachable: retry loop completed without result');
  }

  Future<T> executeWithCondition<T>({
    required Future<T> Function() action,
    required bool Function(T) successCondition,
    int? maxRetries,
  }) async {
    final retries = maxRetries ?? this.maxRetries;
    int attempt = 0;

    while (attempt <= retries) {
      try {
        final result = await action();
        if (successCondition(result)) {
          return result;
        }
        attempt++;
        if (attempt > retries) {
          throw StateError('Condition not met after $retries attempts');
        }
        await Future.delayed(getDelay(attempt));
      } catch (e) {
        attempt++;
        if (!canRetry(attempt, e) || attempt > retries) rethrow;
        await Future.delayed(getDelay(attempt));
      }
    }

    throw StateError('Unreachable: executeWithCondition loop completed without result');
  }
}
