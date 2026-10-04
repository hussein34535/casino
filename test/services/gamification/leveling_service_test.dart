import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/data/models/gamification/level_reward_model.dart';
import 'package:game_show_app/services/gamification/leveling_service.dart';

void main() {
  late LevelingService levelingService;

  setUp(() {
    levelingService = LevelingService();
  });

  group('LevelingService', () {
    group('calculateLevel', () {
      test('should return level 1 for 0 XP', () {
        expect(levelingService.calculateLevel(0), 1);
      });

      test('should return level 1 for 99 XP', () {
        expect(levelingService.calculateLevel(99), 1);
      });

      test('should return level 2 for 100 XP', () {
        expect(levelingService.calculateLevel(100), 2);
      });

      test('should return level 5 for 400 XP', () {
        expect(levelingService.calculateLevel(400), 5);
      });

      test('should return level 10 for 900 XP', () {
        expect(levelingService.calculateLevel(900), 10);
      });
    });

    group('getTotalXpForLevel', () {
      test('should return 0 for level 1', () {
        expect(levelingService.getTotalXpForLevel(1), 0);
      });

      test('should return 100 for level 2', () {
        expect(levelingService.getTotalXpForLevel(2), 100);
      });

      test('should return 500 for level 6', () {
        expect(levelingService.getTotalXpForLevel(6), 500);
      });
    });

    group('getXpForNextLevel', () {
      test('should return 100 for 0 XP', () {
        expect(levelingService.getXpForNextLevel(0), 100);
      });

      test('should return 50 for 50 XP', () {
        expect(levelingService.getXpForNextLevel(50), 50);
      });

      test('should return 100 for 100 XP', () {
        expect(levelingService.getXpForNextLevel(100), 100);
      });
    });

    group('getLevelRewards', () {
      test('should return reward for level 5', () {
        final rewards = levelingService.getLevelRewards(5);
        expect(rewards.length, 1);
        expect(rewards[0].level, 5);
        expect(rewards[0].type, LevelRewardType.item);
        expect(rewards[0].itemId, 'avatar_lvl5');
      });

      test('should return reward for level 10', () {
        final rewards = levelingService.getLevelRewards(10);
        expect(rewards.length, 1);
        expect(rewards[0].level, 10);
        expect(rewards[0].type, LevelRewardType.coins);
        expect(rewards[0].amount, 500);
      });

      test('should return empty for level without rewards', () {
        final rewards = levelingService.getLevelRewards(3);
        expect(rewards, isEmpty);
      });

      test('should return reward for level 50', () {
        final rewards = levelingService.getLevelRewards(50);
        expect(rewards.length, 1);
        expect(rewards[0].level, 50);
        expect(rewards[0].type, LevelRewardType.badge);
      });
    });
  });
}
