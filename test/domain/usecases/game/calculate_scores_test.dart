import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/data/models/game/player_model.dart';
import 'package:game_show_app/domain/usecases/game/calculate_scores.dart';

void main() {
  group('CalculateScores', () {
    late CalculateScores useCase;

    setUp(() {
      useCase = CalculateScores();
    });

    test('returns players sorted by score descending', () {
      final players = [
        PlayerModel(id: 'p1', name: 'Alice', score: 50),
        PlayerModel(id: 'p2', name: 'Bob', score: 100),
        PlayerModel(id: 'p3', name: 'Charlie', score: 75),
      ];

      final sorted = useCase.call(players);
      expect(sorted[0].name, 'Bob');
      expect(sorted[1].name, 'Charlie');
      expect(sorted[2].name, 'Alice');
    });

    test('handles ties correctly (stable relative order not guaranteed)', () {
      final players = [
        PlayerModel(id: 'p1', name: 'Alice', score: 100),
        PlayerModel(id: 'p2', name: 'Bob', score: 100),
        PlayerModel(id: 'p3', name: 'Charlie', score: 50),
      ];

      final sorted = useCase.call(players);
      expect(sorted[0].score, 100);
      expect(sorted[1].score, 100);
      expect(sorted[2].score, 50);
    });

    test('does not mutate original list', () {
      final players = [
        PlayerModel(id: 'p1', name: 'Alice', score: 30),
        PlayerModel(id: 'p2', name: 'Bob', score: 90),
      ];

      final originalIds = players.map((p) => p.id).toList();
      useCase.call(players);
      expect(players.map((p) => p.id).toList(), originalIds);
    });

    test('returns empty list for empty input', () {
      final sorted = useCase.call([]);
      expect(sorted, []);
    });

    test('handles single player', () {
      final players = [PlayerModel(id: 'p1', name: 'Solo', score: 50)];
      final sorted = useCase.call(players);
      expect(sorted.length, 1);
      expect(sorted.first.name, 'Solo');
    });

    test('all players have correct scores in result', () {
      final players = [
        PlayerModel(id: 'p1', name: 'Alice', score: 200),
        PlayerModel(id: 'p2', name: 'Bob', score: 150),
        PlayerModel(id: 'p3', name: 'Charlie', score: 300),
      ];

      final sorted = useCase.call(players);
      expect(sorted[0].score, 300);
      expect(sorted[1].score, 200);
      expect(sorted[2].score, 150);
    });
  });
}
