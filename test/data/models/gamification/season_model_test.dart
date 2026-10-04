import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/data/models/gamification/season_model.dart';

void main() {
  group('SeasonReward', () {
    final testJson = {
      'level': 5,
      'description': {'ar': 'مكافأة', 'en': 'Reward'},
      'xpReward': 200,
      'coinReward': 100,
      'itemId': 'item1',
      'isPremium': true,
    };

    test('fromJson creates model correctly', () {
      final reward = SeasonReward.fromJson(testJson);
      expect(reward.level, 5);
      expect(reward.xpReward, 200);
      expect(reward.coinReward, 100);
      expect(reward.itemId, 'item1');
      expect(reward.isPremium, true);
    });

    test('toJson produces correct map', () {
      final reward = SeasonReward.fromJson(testJson);
      final json = reward.toJson();
      expect(json['level'], 5);
      expect(json['xpReward'], 200);
      expect(json['coinReward'], 100);
      expect(json['isPremium'], true);
    });

    test('fromJson uses default values for missing fields', () {
      final reward = SeasonReward.fromJson({});
      expect(reward.level, 0);
      expect(reward.xpReward, 0);
      expect(reward.coinReward, 0);
      expect(reward.itemId, isNull);
      expect(reward.isPremium, false);
    });
  });

  group('SeasonModel', () {
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 10));
    final endDate = now.add(const Duration(days: 20));
    final reward = SeasonReward(
      level: 1,
      xpReward: 100,
      coinReward: 50,
    );

    final testJson = {
      'id': 'season1',
      'name': {'ar': 'الموسم الأول', 'en': 'Season 1'},
      'isActive': true,
      'battlePassPrice': 500,
      'rewards': [reward.toJson()],
    };

    test('fromJson creates model correctly', () {
      final json = {
        ...testJson,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      };
      final season = SeasonModel.fromJson(json);
      expect(season.id, 'season1');
      expect(season.name, {'ar': 'الموسم الأول', 'en': 'Season 1'});
      expect(season.isActive, true);
      expect(season.battlePassPrice, 500);
      expect(season.rewards.length, 1);
      expect(season.rewards.first.level, 1);
    });

    test('toJson produces correct map', () {
      final season = SeasonModel(
        id: 'season1',
        startDate: startDate,
        endDate: endDate,
        isActive: true,
        battlePassPrice: 500,
        rewards: [reward],
      );
      final json = season.toJson();
      expect(json['id'], 'season1');
      expect(json['isActive'], true);
      expect(json['battlePassPrice'], 500);
      expect((json['rewards'] as List).length, 1);
    });

    test('fromJson uses default values for missing fields', () {
      final season = SeasonModel.fromJson({});
      expect(season.id, '');
      expect(season.name, {'ar': '', 'en': ''});
      expect(season.isActive, false);
      expect(season.battlePassPrice, 0);
      expect(season.rewards, []);
    });

    group('date validation', () {
      test('startDate comes before endDate in valid season', () {
        final season = SeasonModel(
          id: 's1',
          startDate: DateTime(2025, 1, 1),
          endDate: DateTime(2025, 2, 1),
        );
        expect(season.endDate.isAfter(season.startDate), true);
      });

      test('startDate and endDate can be the same', () {
        final date = DateTime(2025, 1, 1);
        final season = SeasonModel(
          id: 's1',
          startDate: date,
          endDate: date,
        );
        expect(season.endDate, season.startDate);
      });

      test('endDate can be far in the future', () {
        final season = SeasonModel(
          id: 's1',
          startDate: DateTime(2025, 1, 1),
          endDate: DateTime(2030, 12, 31),
        );
        expect(season.endDate.difference(season.startDate).inDays, greaterThan(365 * 5));
      });

      test('dates are preserved through toJson', () {
        final season = SeasonModel(
          id: 's1',
          startDate: DateTime(2025, 6, 15),
          endDate: DateTime(2025, 9, 15),
        );
        final json = season.toJson();
        expect(json['startDate'], DateTime(2025, 6, 15));
        expect(json['endDate'], DateTime(2025, 9, 15));
      });
    });

    test('constructor sets default name', () {
      final season = SeasonModel(
        id: 's1',
        startDate: DateTime.now(),
        endDate: DateTime.now(),
      );
      expect(season.name, {'ar': 'موسم جديد', 'en': 'New Season'});
    });
  });
}
