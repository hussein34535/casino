import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/data/models/game/player_model.dart';
import 'package:game_show_app/data/models/question/question_model.dart';

void main() {
  group('PlayerModel', () {
    test('should create with default values', () {
      final player = PlayerModel(id: '1', name: 'Test');
      expect(player.score, 0);
      expect(player.yellowCards, 0);
      expect(player.redCards, 0);
    });

    test('should serialize and deserialize', () {
      final player = PlayerModel(id: '1', name: 'Test', score: 10);
      final json = player.toJson();
      final deserialized = PlayerModel.fromJson(json);
      expect(deserialized.id, player.id);
      expect(deserialized.name, player.name);
      expect(deserialized.score, player.score);
    });
  });

  group('QuestionModel', () {
    test('should create question', () {
      final q = QuestionModel(id: '1', type: 'trivia', text: 'Test question?', answer: 'Answer');
      expect(q.text, 'Test question?');
      expect(q.answer, 'Answer');
    });

    test('should have type gradients', () {
      expect(QuestionModel.typeGradients.containsKey('trivia'), true);
      expect(QuestionModel.typeGradients.containsKey('movies'), true);
    });
  });

  group('LocalPlayer', () {
    test('should create with default values', () {
      final player = LocalPlayer(name: 'Test');
      expect(player.score, 0);
      expect(player.yellowCards, 0);
    });

    test('should allow score modification', () {
      final player = LocalPlayer(name: 'Test', score: 5);
      player.score += 3;
      expect(player.score, 8);
    });
  });
}
