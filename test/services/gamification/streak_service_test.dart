import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/services/gamification/streak_service.dart';

void main() {
  late StreakService streakService;

  setUp(() {
    streakService = StreakService(FirebaseFirestore.instance);
  });

  group('StreakService', () {
    group('getStreak', () {
      test('should return null when no streak exists', () async {
        final streak = await streakService.getStreak('nonexistent_user');
        expect(streak, isNull);
      });
    });

    group('updateStreak', () {
      test('should create new streak for first-time user', () async {
        final streak = await streakService.updateStreak('new_user_${DateTime.now().millisecondsSinceEpoch}');
        expect(streak.userId, isNotNull);
        expect(streak.currentStreak, 1);
        expect(streak.longestStreak, 1);
      });
    });

    group('getStreakRewards', () {
      test('should return streak rewards list', () {
        final rewards = streakService.getStreakRewards();
        expect(rewards.length, 4);
      });

      test('should have day 3 reward as coins', () {
        final rewards = streakService.getStreakRewards();
        expect(rewards[0]['day'], 3);
        expect(rewards[0]['type'], 'coins');
        expect(rewards[0]['amount'], 50);
      });

      test('should have day 30 reward as bundle', () {
        final rewards = streakService.getStreakRewards();
        expect(rewards[3]['day'], 30);
        expect(rewards[3]['type'], 'bundle');
        expect(rewards[3]['itemId'], 'streak_master');
      });
    });
  });
}