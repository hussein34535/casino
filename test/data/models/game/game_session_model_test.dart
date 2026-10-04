import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/data/models/game/game_session_model.dart';
import 'package:game_show_app/data/models/game/player_model.dart';

void main() {
  group('GameSessionModel', () {
    final testPlayer = PlayerModel(id: 'p1', name: 'Player 1', score: 100);
    final testJson = {
      'id': 'session1',
      'hostId': 'host1',
      'roomCode': 'ABC123',
      'categories': ['trivia'],
      'status': 'waiting',
      'players': [testPlayer.toJson()],
      'currentQuestionIndex': 0,
      'maxQuestions': 20,
      'roundTime': 30,
      'isPublic': true,
      'winnerId': null,
      'usedQuestionIds': ['q1', 'q2'],
      'scores': {'p1': 100, 'p2': 50},
    };

    test('fromJson creates model correctly', () {
      final session = GameSessionModel.fromJson(testJson);
      expect(session.id, 'session1');
      expect(session.hostId, 'host1');
      expect(session.roomCode, 'ABC123');
      expect(session.categories, ['trivia']);
      expect(session.status, 'waiting');
      expect(session.players.length, 1);
      expect(session.players.first.name, 'Player 1');
      expect(session.currentQuestionIndex, 0);
      expect(session.maxQuestions, 20);
      expect(session.roundTime, 30);
      expect(session.isPublic, true);
      expect(session.winnerId, isNull);
      expect(session.usedQuestionIds, ['q1', 'q2']);
      expect(session.scores, {'p1': 100, 'p2': 50});
    });

    test('toJson produces correct map', () {
      final session = GameSessionModel.fromJson(testJson);
      final json = session.toJson();
      expect(json['id'], 'session1');
      expect(json['hostId'], 'host1');
      expect(json['roomCode'], 'ABC123');
      expect(json['categories'], ['trivia']);
      expect(json['status'], 'waiting');
      expect((json['players'] as List).length, 1);
      expect(json['scores'], {'p1': 100, 'p2': 50});
    });

    test('fromJson uses default values for missing fields', () {
      final session = GameSessionModel.fromJson({});
      expect(session.id, '');
      expect(session.hostId, '');
      expect(session.roomCode, '');
      expect(session.categories, ['trivia']);
      expect(session.status, 'waiting');
      expect(session.players, []);
      expect(session.currentQuestionIndex, 0);
      expect(session.maxQuestions, 20);
      expect(session.roundTime, 30);
      expect(session.isPublic, false);
      expect(session.winnerId, isNull);
      expect(session.usedQuestionIds, []);
      expect(session.scores, {});
    });

    group('status transitions', () {
      test('default status is waiting', () {
        final session = GameSessionModel(
          id: 's1',
          hostId: 'h1',
          roomCode: 'R1',
          categories: ['trivia'],
        );
        expect(session.status, 'waiting');
      });

      test('status can be updated to in_progress', () {
        final session = GameSessionModel(
          id: 's1',
          hostId: 'h1',
          roomCode: 'R1',
          categories: ['trivia'],
        );
        session.status = 'in_progress';
        expect(session.status, 'in_progress');
      });

      test('status can be updated to completed', () {
        final session = GameSessionModel(
          id: 's1',
          hostId: 'h1',
          roomCode: 'R1',
          categories: ['trivia'],
        );
        session.status = 'completed';
        expect(session.status, 'completed');
      });
    });

    group('score map', () {
      test('starts with empty scores map', () {
        final session = GameSessionModel(
          id: 's1',
          hostId: 'h1',
          roomCode: 'R1',
          categories: ['trivia'],
        );
        expect(session.scores, {});
      });

      test('scores can be added and retrieved', () {
        final session = GameSessionModel(
          id: 's1',
          hostId: 'h1',
          roomCode: 'R1',
          categories: ['trivia'],
          scores: {'p1': 100, 'p2': 200},
        );
        expect(session.scores['p1'], 100);
        expect(session.scores['p2'], 200);
      });

      test('scores are persisted in toJson', () {
        final session = GameSessionModel(
          id: 's1',
          hostId: 'h1',
          roomCode: 'R1',
          categories: ['trivia'],
          scores: {'p1': 100},
        );
        final json = session.toJson();
        expect(json['scores'], {'p1': 100});
      });
    });
  });
}
