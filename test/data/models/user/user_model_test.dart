import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/data/models/user/user_model.dart';

void main() {
  group('UserModel', () {
    final testJson = {
      'id': 'user1',
      'email': 'test@example.com',
      'displayName': 'Test User',
      'photoUrl': 'https://example.com/photo.jpg',
      'language': 'en',
      'xp': 500,
      'level': 5,
      'gamesPlayed': 100,
      'gamesWon': 60,
      'totalScore': 5000,
      'streak': 7,
      'coins': 250,
      'isPremium': true,
      'isAdmin': false,
      'isBanned': false,
      'emailVerified': true,
      'friends': ['user2', 'user3'],
      'blockedUsers': ['user4'],
      'settings': {'theme': 'dark'},
    };

    test('fromJson creates model correctly', () {
      final user = UserModel.fromJson(testJson);
      expect(user.id, 'user1');
      expect(user.email, 'test@example.com');
      expect(user.displayName, 'Test User');
      expect(user.photoUrl, 'https://example.com/photo.jpg');
      expect(user.language, 'en');
      expect(user.xp, 500);
      expect(user.level, 5);
      expect(user.gamesPlayed, 100);
      expect(user.gamesWon, 60);
      expect(user.totalScore, 5000);
      expect(user.streak, 7);
      expect(user.coins, 250);
      expect(user.isPremium, true);
      expect(user.isAdmin, false);
      expect(user.isBanned, false);
      expect(user.emailVerified, true);
      expect(user.friends, ['user2', 'user3']);
      expect(user.blockedUsers, ['user4']);
      expect(user.settings, {'theme': 'dark'});
    });

    test('toJson produces correct map', () {
      final user = UserModel.fromJson(testJson);
      final json = user.toJson();
      expect(json['id'], 'user1');
      expect(json['email'], 'test@example.com');
      expect(json['displayName'], 'Test User');
      expect(json['xp'], 500);
      expect(json['gamesPlayed'], 100);
      expect(json['gamesWon'], 60);
    });

    test('fromJson uses default values for missing fields', () {
      final minimalJson = <String, dynamic>{};
      final user = UserModel.fromJson(minimalJson);
      expect(user.id, '');
      expect(user.email, '');
      expect(user.displayName, '');
      expect(user.language, 'ar');
      expect(user.xp, 0);
      expect(user.level, 1);
      expect(user.gamesPlayed, 0);
      expect(user.gamesWon, 0);
      expect(user.totalScore, 0);
      expect(user.streak, 0);
      expect(user.coins, 0);
      expect(user.isPremium, false);
      expect(user.isAdmin, false);
      expect(user.isBanned, false);
      expect(user.emailVerified, false);
      expect(user.friends, []);
      expect(user.blockedUsers, []);
      expect(user.settings, {});
    });

    group('winRate', () {
      test('calculates win rate correctly', () {
        final user = UserModel(
          id: 'test',
          email: 'test@test.com',
          displayName: 'Test',
          gamesPlayed: 100,
          gamesWon: 25,
        );
        expect(user.winRate, 0.25);
      });

      test('returns 0 when no games played', () {
        final user = UserModel(
          id: 'test',
          email: 'test@test.com',
          displayName: 'Test',
          gamesPlayed: 0,
          gamesWon: 0,
        );
        expect(user.winRate, 0);
      });

      test('returns 1.0 when all games won', () {
        final user = UserModel(
          id: 'test',
          email: 'test@test.com',
          displayName: 'Test',
          gamesPlayed: 50,
          gamesWon: 50,
        );
        expect(user.winRate, 1.0);
      });
    });

    test('constructor sets default createdAt and empty lists', () {
      final user = UserModel(
        id: 'test',
        email: 'test@test.com',
        displayName: 'Test',
      );
      expect(user.createdAt, isA<DateTime>());
      expect(user.friends, []);
      expect(user.blockedUsers, []);
      expect(user.settings, {});
    });
  });
}
