import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/core/infrastructure/retry_policy.dart';

void main() {
  late RetryPolicy retryPolicy;

  setUp(() {
    retryPolicy = const RetryPolicy(maxRetries: 3, baseDelay: Duration(milliseconds: 50));
  });

  group('RetryPolicy', () {
    test('execute should return successful result', () async {
      final result = await retryPolicy.execute(() async => 42);
      expect(result, 42);
    });

    test('execute should retry on failure', () async {
      var attempts = 0;
      final result = await retryPolicy.execute(() async {
        attempts++;
        if (attempts < 3) throw Exception('Temporary error');
        return 'success';
      });
      expect(result, 'success');
      expect(attempts, 3);
    });

    test('execute should throw after max retries exceeded', () async {
      var attempts = 0;
      await expectLater(
        () => retryPolicy.execute(() async {
          attempts++;
          throw Exception('Persistent error');
        }),
        throwsException,
      );
      expect(attempts, 4);
    });

    test('execute should not retry on FormatException', () async {
      var attempts = 0;
      expect(
        () => retryPolicy.execute(() async {
          attempts++;
          throw FormatException('Bad format');
        }),
        throwsFormatException,
      );
      expect(attempts, 1);
    });

    test('execute should not retry on ArgumentError', () async {
      var attempts = 0;
      expect(
        () => retryPolicy.execute(() async {
          attempts++;
          throw ArgumentError('Invalid arg');
        }),
        throwsArgumentError,
      );
      expect(attempts, 1);
    });

    test('execute should use custom maxRetries', () async {
      var attempts = 0;
      await expectLater(
        () => retryPolicy.execute(
          () async {
            attempts++;
            throw Exception('Error');
          },
          maxRetries: 1,
        ),
        throwsException,
      );
      expect(attempts, 2);
    });

    test('executeWithCondition should retry until condition met', () async {
      var attempts = 0;
      final result = await retryPolicy.executeWithCondition(
        action: () async {
          attempts++;
          return attempts;
        },
        successCondition: (value) => value >= 3,
      );
      expect(result, 3);
      expect(attempts, 3);
    });

    test('executeWithCondition should throw when condition never met', () async {
      expect(
        () => retryPolicy.executeWithCondition(
          action: () async => 0,
          successCondition: (value) => value > 0,
          maxRetries: 2,
        ),
        throwsStateError,
      );
    });

    test('canRetry should return false when attempt exceeds maxRetries', () {
      expect(retryPolicy.canRetry(4, Exception('test')), false);
    });

    test('canRetry should return true when attempt equals maxRetries', () {
      expect(retryPolicy.canRetry(3, Exception('test')), true);
    });

    test('canRetry should return false when lastError is null', () {
      expect(retryPolicy.canRetry(0, null), false);
    });

    test('canRetry should return true for retryable errors', () {
      expect(retryPolicy.canRetry(0, Exception('test')), true);
    });

    test('getDelay should return increasing delay with jitter', () {
      final delay1 = retryPolicy.getDelay(0);
      final delay2 = retryPolicy.getDelay(1);
      expect(delay2.inMilliseconds, greaterThan(delay1.inMilliseconds));
    });
  });
}
