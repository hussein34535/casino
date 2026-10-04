import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/data/models/achievement/achievement_model.dart';

void main() {
  group('AchievementModel', () {
    final testJson = {
      'id': 'ach1',
      'name': 'First Win',
      'description': 'Win your first game',
      'iconName': 'trophy',
      'requiredProgress': 1,
      'xpReward': 100,
      'coinReward': 50,
      'isHidden': false,
      'category': 'games',
    };

    test('fromJson creates model correctly', () {
      final ach = AchievementModel.fromJson(testJson);
      expect(ach.id, 'ach1');
      expect(ach.name, 'First Win');
      expect(ach.description, 'Win your first game');
      expect(ach.iconName, 'trophy');
      expect(ach.requiredProgress, 1);
      expect(ach.xpReward, 100);
      expect(ach.coinReward, 50);
      expect(ach.isHidden, false);
      expect(ach.category, 'games');
    });

    test('toJson produces correct map', () {
      final ach = AchievementModel.fromJson(testJson);
      final json = ach.toJson();
      expect(json['id'], 'ach1');
      expect(json['name'], 'First Win');
      expect(json['requiredProgress'], 1);
      expect(json['xpReward'], 100);
    });

    test('fromJson uses default values for missing fields', () {
      final ach = AchievementModel.fromJson({});
      expect(ach.id, '');
      expect(ach.name, '');
      expect(ach.description, '');
      expect(ach.iconName, 'trophy');
      expect(ach.requiredProgress, 0);
      expect(ach.xpReward, 0);
      expect(ach.coinReward, 0);
      expect(ach.isHidden, false);
      expect(ach.category, isNull);
    });

    test('constructor sets defaults', () {
      final ach = AchievementModel(
        id: 'ach1',
        name: 'Test',
        description: 'Test desc',
      );
      expect(ach.iconName, 'trophy');
      expect(ach.requiredProgress, 0);
      expect(ach.xpReward, 0);
      expect(ach.coinReward, 0);
      expect(ach.isHidden, false);
      expect(ach.category, isNull);
    });
  });

  group('UserAchievement', () {
    final testJson = {
      'id': 'ua1',
      'achievementId': 'ach1',
      'userId': 'user1',
      'progress': 5,
      'isUnlocked': true,
      'rewardClaimed': false,
    };

    test('fromJson creates model correctly', () {
      final ua = UserAchievement.fromJson(testJson);
      expect(ua.id, 'ua1');
      expect(ua.achievementId, 'ach1');
      expect(ua.userId, 'user1');
      expect(ua.progress, 5);
      expect(ua.isUnlocked, true);
      expect(ua.rewardClaimed, false);
      expect(ua.unlockedAt, isNull);
    });

    test('toJson produces correct map', () {
      final ua = UserAchievement.fromJson(testJson);
      final json = ua.toJson();
      expect(json['id'], 'ua1');
      expect(json['achievementId'], 'ach1');
      expect(json['userId'], 'user1');
      expect(json['progress'], 5);
      expect(json['isUnlocked'], true);
      expect(json['rewardClaimed'], false);
    });

    test('fromJson uses default values for missing fields', () {
      final ua = UserAchievement.fromJson({});
      expect(ua.id, '');
      expect(ua.achievementId, '');
      expect(ua.userId, '');
      expect(ua.progress, 0);
      expect(ua.isUnlocked, false);
      expect(ua.rewardClaimed, false);
      expect(ua.unlockedAt, isNull);
    });

    group('progress and unlock logic', () {
      test('starts with progress 0 and locked', () {
        final ua = UserAchievement(
          id: 'ua1',
          achievementId: 'ach1',
          userId: 'user1',
        );
        expect(ua.progress, 0);
        expect(ua.isUnlocked, false);
      });

      test('progress can be incremented', () {
        final ua = UserAchievement(
          id: 'ua1',
          achievementId: 'ach1',
          userId: 'user1',
        );
        ua.progress = 5;
        expect(ua.progress, 5);
      });

      test('can be unlocked', () {
        final ua = UserAchievement(
          id: 'ua1',
          achievementId: 'ach1',
          userId: 'user1',
        );
        ua.isUnlocked = true;
        expect(ua.isUnlocked, true);
      });

      test('rewardClaimed starts false', () {
        final ua = UserAchievement(
          id: 'ua1',
          achievementId: 'ach1',
          userId: 'user1',
        );
        expect(ua.rewardClaimed, false);
      });
    });
  });
}
