import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/core/infrastructure/date_utils.dart';

void main() {
  group('DateUtils.timeAgo', () {
    test('should return "الآن" for recent time', () {
      final now = DateTime.now();
      expect(DateUtils.timeAgo(now), 'الآن');
      expect(DateUtils.timeAgo(now.subtract(const Duration(seconds: 30))), 'الآن');
    });

    test('should return minutes ago', () {
      final date = DateTime.now().subtract(const Duration(minutes: 5));
      expect(DateUtils.timeAgo(date), 'منذ 5 دقيقة');
    });

    test('should return hours ago', () {
      final date = DateTime.now().subtract(const Duration(hours: 3));
      expect(DateUtils.timeAgo(date), 'منذ 3 ساعة');
    });

    test('should return days ago', () {
      final date = DateTime.now().subtract(const Duration(days: 2));
      expect(DateUtils.timeAgo(date), 'منذ 2 أيام');
    });

    test('should return weeks ago', () {
      final date = DateTime.now().subtract(const Duration(days: 14));
      expect(DateUtils.timeAgo(date), 'منذ 2 أسابيع');
    });

    test('should return months ago', () {
      final date = DateTime.now().subtract(const Duration(days: 60));
      expect(DateUtils.timeAgo(date), 'منذ 2 شهر');
    });

    test('should return years ago', () {
      final date = DateTime.now().subtract(const Duration(days: 400));
      expect(DateUtils.timeAgo(date), 'منذ 1 سنة');
    });
  });

  group('DateUtils.isToday', () {
    test('should return true for today', () {
      expect(DateUtils.isToday(DateTime.now()), true);
    });

    test('should return false for yesterday', () {
      expect(DateUtils.isToday(DateTime.now().subtract(const Duration(days: 1))), false);
    });

    test('should return false for tomorrow', () {
      expect(DateUtils.isToday(DateTime.now().add(const Duration(days: 1))), false);
    });
  });

  group('DateUtils.isYesterday', () {
    test('should return true for yesterday', () {
      expect(DateUtils.isYesterday(DateTime.now().subtract(const Duration(days: 1))), true);
    });

    test('should return false for today', () {
      expect(DateUtils.isYesterday(DateTime.now()), false);
    });

    test('should return false for two days ago', () {
      expect(DateUtils.isYesterday(DateTime.now().subtract(const Duration(days: 2))), false);
    });
  });

  group('DateUtils.daysBetween', () {
    test('should return 0 for same day', () {
      final date = DateTime(2026, 1, 15);
      expect(DateUtils.daysBetween(date, date), 0);
    });

    test('should return positive difference', () {
      final a = DateTime(2026, 1, 1);
      final b = DateTime(2026, 1, 10);
      expect(DateUtils.daysBetween(a, b), 9);
    });

    test('should return absolute difference when reversed', () {
      final a = DateTime(2026, 1, 10);
      final b = DateTime(2026, 1, 1);
      expect(DateUtils.daysBetween(a, b), 9);
    });

    test('should ignore time component', () {
      final a = DateTime(2026, 1, 1, 23, 59);
      final b = DateTime(2026, 1, 2, 0, 1);
      expect(DateUtils.daysBetween(a, b), 1);
    });
  });

  group('DateUtils.formatDuration', () {
    test('should format days', () {
      expect(DateUtils.formatDuration(const Duration(days: 3)), '3 يوم');
    });

    test('should format hours', () {
      expect(DateUtils.formatDuration(const Duration(hours: 5)), '5 ساعة');
    });

    test('should format minutes', () {
      expect(DateUtils.formatDuration(const Duration(minutes: 30)), '30 دقيقة');
    });

    test('should format seconds', () {
      expect(DateUtils.formatDuration(const Duration(seconds: 45)), '45 ثانية');
    });

    test('should prioritize larger units', () {
      expect(DateUtils.formatDuration(const Duration(days: 1, hours: 12)), '1 يوم');
    });
  });

  group('DateUtils.formatDurationMs', () {
    test('should convert milliseconds to duration', () {
      expect(DateUtils.formatDurationMs(5000), '5 ثانية');
      expect(DateUtils.formatDurationMs(120000), '2 دقيقة');
    });
  });

  group('DateUtils.formatTimeRemaining', () {
    test('should return "انتهى" for past time', () {
      expect(DateUtils.formatTimeRemaining(DateTime.now().subtract(const Duration(hours: 1))), 'انتهى');
    });

    test('should return remaining time for future', () {
      final future = DateTime.now().add(const Duration(hours: 2));
      expect(DateUtils.formatTimeRemaining(future), '2 ساعة');
    });
  });
}
