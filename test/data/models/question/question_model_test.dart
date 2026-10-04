import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:game_show_app/data/models/question/question_model.dart';

void main() {
  group('QuestionModel', () {
    final testJson = {
      'id': 'q1',
      'type': 'trivia',
      'text': 'What is 2+2?',
      'answer': '4',
      'audioUrl': 'https://example.com/audio.mp3',
      'singerName': 'Singer',
      'songName': 'Song',
      'imageUrl': 'https://example.com/img.jpg',
      'category': 'math',
      'difficulty': 'hard',
      'isActive': true,
      'timesUsed': 10,
      'createdBy': 'user1',
      'reportCount': 1,
      'isApproved': true,
      'points': 100,
    };

    test('fromJson creates model correctly', () {
      final q = QuestionModel.fromJson(testJson);
      expect(q.id, 'q1');
      expect(q.type, 'trivia');
      expect(q.text, 'What is 2+2?');
      expect(q.answer, '4');
      expect(q.audioUrl, 'https://example.com/audio.mp3');
      expect(q.singerName, 'Singer');
      expect(q.songName, 'Song');
      expect(q.imageUrl, 'https://example.com/img.jpg');
      expect(q.category, 'math');
      expect(q.difficulty, 'hard');
      expect(q.isActive, true);
      expect(q.timesUsed, 10);
      expect(q.createdBy, 'user1');
      expect(q.reportCount, 1);
      expect(q.isApproved, true);
      expect(q.points, 100);
    });

    test('toJson produces correct map', () {
      final q = QuestionModel.fromJson(testJson);
      final json = q.toJson();
      expect(json['id'], 'q1');
      expect(json['type'], 'trivia');
      expect(json['text'], 'What is 2+2?');
      expect(json['answer'], '4');
      expect(json['difficulty'], 'hard');
    });

    test('fromJson uses default values for missing fields', () {
      final q = QuestionModel.fromJson({});
      expect(q.id, '');
      expect(q.type, '');
      expect(q.text, '');
      expect(q.answer, isNull);
      expect(q.difficulty, 'easy');
      expect(q.isActive, true);
      expect(q.timesUsed, 0);
      expect(q.reportCount, 0);
      expect(q.isApproved, true);
      expect(q.points, 0);
    });

    group('typeGradients', () {
      test('contains expected types', () {
        expect(QuestionModel.typeGradients.containsKey('trivia'), true);
        expect(QuestionModel.typeGradients.containsKey('movies'), true);
        expect(QuestionModel.typeGradients.containsKey('music'), true);
        expect(QuestionModel.typeGradients.containsKey('puzzles'), true);
        expect(QuestionModel.typeGradients.containsKey('words'), true);
      });

      test('gradients have two colors', () {
        for (final entry in QuestionModel.typeGradients.entries) {
          expect(entry.value.length, 2);
          expect(entry.value[0], isA<Color>());
          expect(entry.value[1], isA<Color>());
        }
      });

      test('trivia gradient colors are correct', () {
        final gradient = QuestionModel.typeGradients['trivia']!;
        expect(gradient[0], const Color(0xFF1A237E));
        expect(gradient[1], const Color(0xFF3F51B5));
      });
    });

    group('difficulty levels', () {
      test('default difficulty is easy', () {
        final q = QuestionModel(
          id: 'q1',
          type: 'trivia',
          text: 'Question',
        );
        expect(q.difficulty, 'easy');
      });

      test('can set hard difficulty', () {
        final q = QuestionModel(
          id: 'q1',
          type: 'trivia',
          text: 'Question',
          difficulty: 'hard',
        );
        expect(q.difficulty, 'hard');
      });

      test('toJson preserves difficulty', () {
        final q = QuestionModel(
          id: 'q1',
          type: 'trivia',
          text: 'Question',
          difficulty: 'medium',
        );
        expect(q.toJson()['difficulty'], 'medium');
      });
    });
  });
}
