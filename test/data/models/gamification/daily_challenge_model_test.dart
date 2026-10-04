import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/data/models/gamification/daily_challenge_model.dart';

void main() {
  group('DailyChallengeModel', () {
    final testJson = {
      'id': 'dc1',
      'title': {'ar': 'تحدي يومي', 'en': 'Daily Challenge'},
      'description': {'ar': 'أكمل التحدي', 'en': 'Complete the challenge'},
      'xpReward': 100,
      'coinReward': 50,
      'progress': 3,
      'requiredProgress': 5,
      'requiredAmount': 5,
      'isCompleted': false,
      'rewardClaimed': false,
      'type': 'daily',
      'period': 'daily',
      'iconName': 'star',
    };

    test('fromJson creates model correctly', () {
      final dc = DailyChallengeModel.fromJson(testJson);
      expect(dc.id, 'dc1');
      expect(dc.xpReward, 100);
      expect(dc.coinReward, 50);
      expect(dc.progress, 3);
      expect(dc.requiredProgress, 5);
      expect(dc.requiredAmount, 5);
      expect(dc.isCompleted, false);
      expect(dc.rewardClaimed, false);
      expect(dc.type, ChallengeType.daily);
      expect(dc.period, ChallengePeriod.daily);
      expect(dc.iconName, 'star');
    });

    test('toJson produces correct map', () {
      final dc = DailyChallengeModel.fromJson(testJson);
      final json = dc.toJson();
      expect(json['id'], 'dc1');
      expect(json['xpReward'], 100);
      expect(json['progress'], 3);
      expect(json['type'], 'daily');
      expect(json['period'], 'daily');
    });

    test('fromJson uses default values for missing fields', () {
      final dc = DailyChallengeModel.fromJson({});
      expect(dc.id, '');
      expect(dc.xpReward, 0);
      expect(dc.coinReward, 0);
      expect(dc.progress, 0);
      expect(dc.requiredProgress, 1);
      expect(dc.requiredAmount, 1);
      expect(dc.isCompleted, false);
      expect(dc.rewardClaimed, false);
      expect(dc.type, ChallengeType.daily);
      expect(dc.period, ChallengePeriod.daily);
      expect(dc.iconName, '');
    });

    group('completedAt logic', () {
      test('isCompleted defaults to false', () {
        final dc = DailyChallengeModel(id: 'dc1');
        expect(dc.isCompleted, false);
      });

      test('isCompleted can be set to true', () {
        final dc = DailyChallengeModel(id: 'dc1', isCompleted: true);
        expect(dc.isCompleted, true);
      });

      test('rewardClaimed defaults to false', () {
        final dc = DailyChallengeModel(id: 'dc1');
        expect(dc.rewardClaimed, false);
      });
    });

    group('progressFraction getter', () {
      test('returns 0 when requiredAmount is 0', () {
        final dc = DailyChallengeModel(
          id: 'dc1',
          requiredAmount: 0,
          progress: 5,
        );
        expect(dc.progressFraction, 0.0);
      });

      test('returns correct fraction', () {
        final dc = DailyChallengeModel(
          id: 'dc1',
          requiredAmount: 10,
          progress: 3,
        );
        expect(dc.progressFraction, 0.3);
      });

      test('returns 1.0 when progress equals requiredAmount', () {
        final dc = DailyChallengeModel(
          id: 'dc1',
          requiredAmount: 5,
          progress: 5,
        );
        expect(dc.progressFraction, 1.0);
      });

      test('returns 0.0 when progress is 0', () {
        final dc = DailyChallengeModel(
          id: 'dc1',
          requiredAmount: 5,
          progress: 0,
        );
        expect(dc.progressFraction, 0.0);
      });
    });

    test('constructor sets default localized strings', () {
      final dc = DailyChallengeModel(id: 'dc1');
      expect(dc.title, {'ar': 'تحدي جديد', 'en': 'New Challenge'});
      expect(dc.description, {
        'ar': 'أكمل التحدي لتحصل على المكافأة',
        'en': 'Complete the challenge to earn rewards',
      });
    });
  });
}
