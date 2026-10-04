import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/data/models/game/player_model.dart';

void main() {
  group('PlayerModel', () {
    final testJson = {
      'id': 'p1',
      'name': 'Player One',
      'score': 100,
      'yellowCards': 2,
      'redCards': 1,
      'userId': 'user1',
      'isOnline': true,
      'avatarUrl': 'https://example.com/avatar.png',
    };

    test('fromJson creates model correctly', () {
      final player = PlayerModel.fromJson(testJson);
      expect(player.id, 'p1');
      expect(player.name, 'Player One');
      expect(player.score, 100);
      expect(player.yellowCards, 2);
      expect(player.redCards, 1);
      expect(player.userId, 'user1');
      expect(player.isOnline, true);
      expect(player.avatarUrl, 'https://example.com/avatar.png');
    });

    test('toJson produces correct map', () {
      final player = PlayerModel.fromJson(testJson);
      final json = player.toJson();
      expect(json['id'], 'p1');
      expect(json['name'], 'Player One');
      expect(json['score'], 100);
      expect(json['isOnline'], true);
    });

    test('fromJson uses default values for missing fields', () {
      final player = PlayerModel.fromJson({});
      expect(player.id, '');
      expect(player.name, '');
      expect(player.score, 0);
      expect(player.yellowCards, 0);
      expect(player.redCards, 0);
      expect(player.userId, isNull);
      expect(player.isOnline, false);
      expect(player.avatarUrl, isNull);
    });

    group('score manipulation', () {
      test('score starts at 0 by default', () {
        final player = PlayerModel(id: 'p1', name: 'Player');
        expect(player.score, 0);
      });

      test('score can be updated', () {
        final player = PlayerModel(id: 'p1', name: 'Player');
        player.score = 50;
        expect(player.score, 50);
      });

      test('score is reflected in toJson', () {
        final player = PlayerModel(id: 'p1', name: 'Player', score: 75);
        expect(player.toJson()['score'], 75);
      });
    });
  });

  group('LocalPlayer', () {
    test('creates with required name', () {
      final player = LocalPlayer(name: 'Local');
      expect(player.name, 'Local');
    });

    test('has default values', () {
      final player = LocalPlayer(name: 'Local');
      expect(player.score, 0);
      expect(player.yellowCards, 0);
      expect(player.redCards, 0);
    });

    test('score can be modified', () {
      final player = LocalPlayer(name: 'Local');
      player.score = 200;
      expect(player.score, 200);
    });

    test('yellowCards can be incremented', () {
      final player = LocalPlayer(name: 'Local');
      player.yellowCards = 3;
      expect(player.yellowCards, 3);
    });

    test('redCards can be incremented', () {
      final player = LocalPlayer(name: 'Local');
      player.redCards = 1;
      expect(player.redCards, 1);
    });
  });
}
