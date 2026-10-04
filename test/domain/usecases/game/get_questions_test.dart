import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/data/models/game/game_session_model.dart';
import 'package:game_show_app/data/models/game/player_model.dart';
import 'package:game_show_app/data/models/question/question_model.dart';
import 'package:game_show_app/domain/usecases/game/get_questions.dart';
import 'package:game_show_app/domain/repositories/game_repository.dart';

class MockGameRepo implements GameRepository {
  List<QuestionModel> _questions = [];
  bool shouldThrow = false;

  void setQuestions(List<QuestionModel> questions) {
    _questions = questions;
  }

  @override
  Future<List<QuestionModel>> getQuestions(String type, {String? difficulty, int limit = 10}) async {
    if (shouldThrow) throw Exception('Repo error');
    var result = _questions.where((q) => q.type == type);
    if (difficulty != null) {
      result = result.where((q) => q.difficulty == difficulty);
    }
    return result.take(limit).toList();
  }

  @override
  Future<String> createSession(GameSessionModel session) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateSession(String id, Map<String, dynamic> data) async {}

  @override
  Stream<GameSessionModel?> sessionStream(String id) => Stream.value(null);

  @override
  Future<void> submitAnswer(String sessionId, String playerId, String questionId, String answer) async {}

  @override
  Future<List<PlayerModel>> getSessionPlayers(String sessionId) async => [];
}

void main() {
  group('GetQuestions', () {
    late MockGameRepo mockRepo;
    late GetQuestions useCase;

    setUp(() {
      mockRepo = MockGameRepo();
      useCase = GetQuestions(mockRepo);
    });

    test('gets questions by type', () async {
      mockRepo.setQuestions([
        QuestionModel(id: '1', type: 'trivia', text: 'Q1'),
        QuestionModel(id: '2', type: 'trivia', text: 'Q2'),
        QuestionModel(id: '3', type: 'music', text: 'Q3'),
      ]);

      final questions = await useCase.call(type: 'trivia');
      expect(questions.length, 2);
      expect(questions.every((q) => q.type == 'trivia'), true);
    });

    test('filters by difficulty', () async {
      mockRepo.setQuestions([
        QuestionModel(id: '1', type: 'trivia', text: 'Q1', difficulty: 'easy'),
        QuestionModel(id: '2', type: 'trivia', text: 'Q2', difficulty: 'hard'),
        QuestionModel(id: '3', type: 'trivia', text: 'Q3', difficulty: 'easy'),
      ]);

      final questions = await useCase.call(type: 'trivia', difficulty: 'hard');
      expect(questions.length, 1);
      expect(questions.first.id, '2');
    });

    test('respects limit parameter', () async {
      mockRepo.setQuestions(List.generate(
        20,
        (i) => QuestionModel(id: '$i', type: 'trivia', text: 'Q$i'),
      ));

      final questions = await useCase.call(type: 'trivia', limit: 5);
      expect(questions.length, 5);
    });

    test('returns empty list when no matches', () async {
      mockRepo.setQuestions([
        QuestionModel(id: '1', type: 'music', text: 'Q1'),
      ]);

      final questions = await useCase.call(type: 'trivia');
      expect(questions, []);
    });

    test('uses default limit of 10', () async {
      mockRepo.setQuestions(List.generate(
        15,
        (i) => QuestionModel(id: '$i', type: 'trivia', text: 'Q$i'),
      ));

      final questions = await useCase.call(type: 'trivia');
      expect(questions.length, 10);
    });

    test('throws ServerFailure when repository fails', () async {
      mockRepo.shouldThrow = true;

      await expectLater(
        () => useCase.call(type: 'trivia'),
        throwsA(isA<ServerFailure>()),
      );
    });

    test('rethrows Failure directly when repository throws Failure', () async {
      mockRepo._questions = [];
      // Simulate repository throwing a Failure directly by overriding
      final failingRepo = _FailingGameRepo();
      final failingUseCase = GetQuestions(failingRepo);

      await expectLater(
        () => failingUseCase.call(type: 'trivia'),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}

class _FailingGameRepo implements GameRepository {
  @override
  Future<List<QuestionModel>> getQuestions(String type, {String? difficulty, int limit = 10}) async {
    throw const ServerFailure(message: 'Custom failure');
  }

  @override
  Future<String> createSession(GameSessionModel session) async => '';
  @override
  Future<void> updateSession(String id, Map<String, dynamic> data) async {}
  @override
  Stream<GameSessionModel?> sessionStream(String id) => Stream.value(null);
  @override
  Future<void> submitAnswer(String sessionId, String playerId, String questionId, String answer) async {}
  @override
  Future<List<PlayerModel>> getSessionPlayers(String sessionId) async => [];
}
