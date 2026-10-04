import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/domain/usecases/user/check_streak.dart';

void main() {
  group('CheckStreak', () {
    late CheckStreak useCase;
    late DateTime today;

    setUp(() {
      useCase = CheckStreak();
      today = DateTime.now();
    });

    group('streak increment', () {
      test('increments streak when last active was yesterday', () {
        final yesterday = DateTime(today.year, today.month, today.day - 1);
        final result = useCase.call(lastActiveAt: yesterday, streak: 5);
        expect(result, 6);
      });

      test('increments from 0 to 1', () {
        final yesterday = DateTime(today.year, today.month, today.day - 1);
        final result = useCase.call(lastActiveAt: yesterday, streak: 0);
        expect(result, 1);
      });

      test('increments from large streak', () {
        final yesterday = DateTime(today.year, today.month, today.day - 1);
        final result = useCase.call(lastActiveAt: yesterday, streak: 100);
        expect(result, 101);
      });
    });

    group('streak reset', () {
      test('resets streak when last active was before yesterday', () {
        final twoDaysAgo = DateTime(today.year, today.month, today.day - 2);
        final result = useCase.call(lastActiveAt: twoDaysAgo, streak: 10);
        expect(result, 0);
      });

      test('resets streak when last active was a week ago', () {
        final weekAgo = DateTime(today.year, today.month, today.day - 7);
        final result = useCase.call(lastActiveAt: weekAgo, streak: 30);
        expect(result, 0);
      });

      test('resets streak when last active was last month', () {
        final lastMonth = DateTime(today.year, today.month - 1, today.day);
        final result = useCase.call(lastActiveAt: lastMonth, streak: 5);
        expect(result, 0);
      });
    });

    group('same day no change', () {
      test('keeps streak when last active was today', () {
        final result = useCase.call(lastActiveAt: today, streak: 7);
        expect(result, 7);
      });

      test('keeps streak at 0 if last active today and streak is 0', () {
        final result = useCase.call(lastActiveAt: today, streak: 0);
        expect(result, 0);
      });

      test('does not modify streak for same day activity', () {
        final result = useCase.call(lastActiveAt: today, streak: 42);
        expect(result, 42);
      });
    });
  });
}
