import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/data/models/leaderboard/leaderboard_model.dart';

void main() {
  group('LeaderboardEntry', () {
    final testJson = {
      'userId': 'user1',
      'displayName': 'Test User',
      'photoUrl': 'https://example.com/photo.jpg',
      'score': 5000,
      'rank': 1,
      'gamesPlayed': 100,
      'wins': 60,
      'period': 'weekly',
    };

    test('fromJson creates model correctly', () {
      final entry = LeaderboardEntry.fromJson(testJson);
      expect(entry.userId, 'user1');
      expect(entry.displayName, 'Test User');
      expect(entry.photoUrl, 'https://example.com/photo.jpg');
      expect(entry.score, 5000);
      expect(entry.rank, 1);
      expect(entry.gamesPlayed, 100);
      expect(entry.wins, 60);
      expect(entry.period, 'weekly');
      expect(entry.updatedAt, isNull);
    });

    test('toJson produces correct map', () {
      final entry = LeaderboardEntry.fromJson(testJson);
      final json = entry.toJson();
      expect(json['userId'], 'user1');
      expect(json['displayName'], 'Test User');
      expect(json['score'], 5000);
      expect(json['rank'], 1);
      expect(json['period'], 'weekly');
    });

    test('fromJson uses default values for missing fields', () {
      final entry = LeaderboardEntry.fromJson({});
      expect(entry.userId, '');
      expect(entry.displayName, '');
      expect(entry.photoUrl, isNull);
      expect(entry.score, 0);
      expect(entry.rank, 0);
      expect(entry.gamesPlayed, 0);
      expect(entry.wins, 0);
      expect(entry.period, 'weekly');
      expect(entry.updatedAt, isNull);
    });

    group('period field', () {
      test('default period is weekly', () {
        final entry = LeaderboardEntry.fromJson({});
        expect(entry.period, 'weekly');
      });

      test('can be monthly', () {
        final json = {...testJson, 'period': 'monthly'};
        final entry = LeaderboardEntry.fromJson(json);
        expect(entry.period, 'monthly');
      });

      test('can be allTime', () {
        final json = {...testJson, 'period': 'allTime'};
        final entry = LeaderboardEntry.fromJson(json);
        expect(entry.period, 'allTime');
      });

      test('period is preserved in toJson', () {
        final json = {...testJson, 'period': 'monthly'};
        final entry = LeaderboardEntry.fromJson(json);
        expect(entry.toJson()['period'], 'monthly');
      });
    });
  });
}
