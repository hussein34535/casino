import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/data/models/gamification/battle_pass_model.dart';

void main() {
  group('BattlePassModel', () {
    final testJson = {
      'id': 'bp1',
      'seasonId': 'season1',
      'userId': 'user1',
      'level': 10,
      'xp': 500,
      'isPremium': true,
      'startLevel': 1,
      'maxLevel': 50,
      'name': {'ar': 'موسم', 'en': 'Season'},
      'rewards': ['reward1', 'reward2'],
    };

    test('fromJson creates model correctly', () {
      final bp = BattlePassModel.fromJson(testJson);
      expect(bp.id, 'bp1');
      expect(bp.seasonId, 'season1');
      expect(bp.userId, 'user1');
      expect(bp.level, 10);
      expect(bp.xp, 500);
      expect(bp.isPremium, true);
      expect(bp.startLevel, 1);
      expect(bp.maxLevel, 50);
      expect(bp.name, {'ar': 'موسم', 'en': 'Season'});
      expect(bp.rewards, ['reward1', 'reward2']);
    });

    test('toJson produces correct map', () {
      final bp = BattlePassModel.fromJson(testJson);
      final json = bp.toJson();
      expect(json['id'], 'bp1');
      expect(json['seasonId'], 'season1');
      expect(json['userId'], 'user1');
      expect(json['level'], 10);
      expect(json['isPremium'], true);
    });

    test('fromJson uses default values for missing fields', () {
      final bp = BattlePassModel.fromJson({});
      expect(bp.id, '');
      expect(bp.seasonId, '');
      expect(bp.userId, '');
      expect(bp.level, 1);
      expect(bp.xp, 0);
      expect(bp.isPremium, false);
      expect(bp.startLevel, 1);
      expect(bp.maxLevel, 50);
      expect(bp.name, {'ar': '', 'en': ''});
      expect(bp.rewards, []);
    });

    group('level progression', () {
      test('default level is 1', () {
        final bp = BattlePassModel(
          id: 'bp1',
          seasonId: 's1',
          userId: 'u1',
        );
        expect(bp.level, 1);
      });

      test('level can be increased', () {
        final bp = BattlePassModel(
          id: 'bp1',
          seasonId: 's1',
          userId: 'u1',
          level: 25,
        );
        expect(bp.level, 25);
      });

      test('maxLevel defaults to 50', () {
        final bp = BattlePassModel(
          id: 'bp1',
          seasonId: 's1',
          userId: 'u1',
        );
        expect(bp.maxLevel, 50);
      });

      test('level changes are reflected in toJson', () {
        final bp = BattlePassModel(
          id: 'bp1',
          seasonId: 's1',
          userId: 'u1',
          level: 30,
        );
        expect(bp.toJson()['level'], 30);
      });
    });

    test('constructor sets default name map', () {
      final bp = BattlePassModel(
        id: 'bp1',
        seasonId: 's1',
        userId: 'u1',
      );
      expect(bp.name, {'ar': 'موسم', 'en': 'Season'});
    });
  });
}
