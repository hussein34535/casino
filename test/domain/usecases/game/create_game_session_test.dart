import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/data/models/game/game_session_model.dart';
import 'package:game_show_app/data/models/game/player_model.dart';
import 'package:game_show_app/data/models/question/question_model.dart';
import 'package:game_show_app/domain/usecases/game/create_game_session.dart';
import 'package:game_show_app/domain/repositories/game_repository.dart';

class MockGameRepo implements GameRepository {
  GameSessionModel? createdSession;
  bool shouldThrow = false;

  @override
  Future<String> createSession(GameSessionModel session) async {
    if (shouldThrow) throw Exception('Creation failed');
    createdSession = session;
    return session.id;
  }

  @override
  Future<List<QuestionModel>> getQuestions(String type, {String? difficulty, int limit = 10}) async {
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
  group('CreateGameSession', () {
    late MockGameRepo mockRepo;
    late CreateGameSession useCase;

    setUp(() {
      mockRepo = MockGameRepo();
      useCase = CreateGameSession(mockRepo);
    });

    test('creates session and returns session id', () async {
      final session = GameSessionModel(
        id: 'session1',
        hostId: 'host1',
        roomCode: 'ROOM1',
        categories: ['trivia'],
      );

      final sessionId = await useCase.call(session);
      expect(sessionId, 'session1');
      expect(mockRepo.createdSession?.id, 'session1');
    });

    test('created session preserves all fields', () async {
      final session = GameSessionModel(
        id: 'session2',
        hostId: 'host2',
        roomCode: 'ROOM2',
        categories: ['music'],
        maxQuestions: 15,
        roundTime: 45,
        isPublic: true,
      );

      await useCase.call(session);
      expect(mockRepo.createdSession?.hostId, 'host2');
      expect(mockRepo.createdSession?.roomCode, 'ROOM2');
      expect(mockRepo.createdSession?.categories, ['music']);
      expect(mockRepo.createdSession?.maxQuestions, 15);
      expect(mockRepo.createdSession?.roundTime, 45);
      expect(mockRepo.createdSession?.isPublic, true);
    });

    test('throws ServerFailure on error', () async {
      mockRepo.shouldThrow = true;
      final session = GameSessionModel(
        id: 'session3',
        hostId: 'host3',
        roomCode: 'ROOM3',
        categories: ['trivia'],
      );

      await expectLater(
        () => useCase.call(session),
        throwsA(isA<ServerFailure>()),
      );
    });

    test('session is created with waiting status by default', () async {
      final session = GameSessionModel(
        id: 'session4',
        hostId: 'host4',
        roomCode: 'ROOM4',
        categories: ['trivia'],
      );

      await useCase.call(session);
      expect(mockRepo.createdSession?.status, 'waiting');
    });
  });
}
