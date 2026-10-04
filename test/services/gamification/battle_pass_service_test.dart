import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/services/gamification/battle_pass_service.dart';

void main() {
  late BattlePassService battlePassService;

  setUp(() {
    battlePassService = BattlePassService(FirebaseFirestore.instance);
  });

  group('BattlePassService', () {
    group('getCurrentSeason', () {
      test('should return null when no active season', () async {
        final season = await battlePassService.getCurrentSeason();
        expect(season, isNull);
      });
    });

    group('getBattlePass', () {
      test('should return null when no battle pass exists', () async {
        final bp = await battlePassService.getBattlePass('user1');
        expect(bp, isNull);
      });
    });

    group('addXp', () {
      test('should add XP without throwing', () async {
        await expectLater(battlePassService.addXp('user1', 100), completes);
      });
    });

    group('claimReward', () {
      test('should return false when battle pass not found', () async {
        final result = await battlePassService.claimReward('nonexistent', 5);
        expect(result, false);
      });
    });

    group('purchasePremium', () {
      test('should return false when battle pass not found', () async {
        final result = await battlePassService.purchasePremium('nonexistent');
        expect(result, false);
      });
    });
  });
}
