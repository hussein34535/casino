import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/data/models/game/game_session_model.dart';
import 'package:game_show_app/data/models/game/player_model.dart';
import 'package:game_show_app/data/models/question/question_model.dart';
import 'package:game_show_app/domain/repositories/game_repository.dart';
import 'package:game_show_app/presentation/providers/game_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class MockRef extends Mock implements Ref {}

class MockGameRepository implements GameRepository {
  List<QuestionModel> questions = [];
  bool shouldThrow = false;

  @override
  Future<List<QuestionModel>> getQuestions(String type, {String? difficulty, int limit = 10}) async {
    if (shouldThrow) throw Exception('Mock error');
    var result = questions.where((q) => q.type == type);
    if (difficulty != null) {
      result = result.where((q) => q.difficulty == difficulty);
    }
    return result.take(limit).toList();
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

void main() {
  group('GameState', () {
    test('initial state has correct defaults', () {
      const state = GameState();
      expect(state.players, isEmpty);
      expect(state.selectedCategories, isNull);
      expect(state.currentQuestionIndex, 0);
      expect(state.isLoading, false);
      expect(state.error, isNull);
    });

    test('copyWith updates fields correctly', () {
      const state = GameState();
      final updated = state.copyWith(isLoading: true);
      expect(updated.isLoading, true);
      expect(updated.players, isEmpty);
    });

    test('currentQuestion returns null when questions empty', () {
      const state = GameState();
      expect(state.currentQuestion, isNull);
    });

    test('currentQuestion returns correct question', () {
      final state = GameState(
        questions: [
          QuestionModel(id: '1', type: 'trivia', text: 'Q1'),
          QuestionModel(id: '2', type: 'trivia', text: 'Q2'),
        ],
        currentQuestionIndex: 1,
      );
      expect(state.currentQuestion?.id, '2');
    });

    test('currentQuestion returns null when index out of bounds', () {
      final state = GameState(
        questions: [QuestionModel(id: '1', type: 'trivia', text: 'Q1')],
        currentQuestionIndex: 5,
      );
      expect(state.currentQuestion, isNull);
    });
  });

  group('GameNotifier', () {
    late MockGameRepository mockRepo;
    late MockRef mockRef;
    late GameNotifier notifier;

    setUp(() {
      mockRepo = MockGameRepository();
      mockRef = MockRef();
      notifier = GameNotifier(mockRepo, mockRef);
    });

    group('setPlayers', () {
      test('creates LocalPlayers from name list', () {
        notifier.setPlayers(['Alice', 'Bob', 'Charlie']);

        expect(notifier.state.players.length, 3);
        expect(notifier.state.players[0].name, 'Alice');
        expect(notifier.state.players[1].name, 'Bob');
        expect(notifier.state.players[2].name, 'Charlie');
      });

      test('resets game state when setting new players', () {
        notifier.setPlayers(['Alice']);
        notifier.setPlayers(['Dave', 'Eve']);

        expect(notifier.state.players.length, 2);
        expect(notifier.state.players[0].name, 'Dave');
      });

      test('all scores start at 0', () {
        notifier.setPlayers(['Alice', 'Bob']);

        expect(notifier.state.players.every((p) => p.score == 0), true);
      });

      test('resets currentQuestionIndex to 0', () {
        notifier.setPlayers(['Alice']);

        expect(notifier.state.currentQuestionIndex, 0);
      });
    });

    group('selectGameType', () {
      test('sets selectedGameType and loading state', () async {
        mockRepo.questions = [
          QuestionModel(id: '1', type: 'trivia', text: 'Q1'),
        ];

        final future = notifier.selectGameType('trivia');
        expect(notifier.state.selectedCategories, ['trivia']);
        expect(notifier.state.isLoading, true);
        expect(notifier.state.questions, isEmpty);

        await future;
      });

      test('loads and shuffles questions from repository', () async {
        mockRepo.questions = List.generate(
          5,
          (i) => QuestionModel(id: '$i', type: 'trivia', text: 'Q$i'),
        );

        await notifier.selectGameType('trivia');

        expect(notifier.state.isLoading, false);
        expect(notifier.state.questions.length, 5);
        expect(notifier.state.error, isNull);
      });

      test('sets error on repository failure', () async {
        mockRepo.shouldThrow = true;

        await notifier.selectGameType('trivia');

        expect(notifier.state.isLoading, false);
        expect(notifier.state.error, isNotNull);
        expect(notifier.state.questions, isEmpty);
      });
    });

    group('updateScore', () {
      test('increases player score by given amount', () {
        notifier.setPlayers(['Alice', 'Bob']);
        notifier.updateScore(0, 10);

        expect(notifier.state.players[0].score, 10);
      });

      test('can add negative amounts', () {
        notifier.setPlayers(['Alice']);
        notifier.updateScore(0, -5);

        expect(notifier.state.players[0].score, -5);
      });

      test('is ignored for invalid player index (negative)', () {
        notifier.setPlayers(['Alice']);
        notifier.updateScore(-1, 10);

        expect(notifier.state.players[0].score, 0);
      });

      test('is ignored for out of bounds player index', () {
        notifier.setPlayers(['Alice']);
        notifier.updateScore(5, 10);

        expect(notifier.state.players[0].score, 0);
      });

      test('accumulates multiple score updates', () {
        notifier.setPlayers(['Alice', 'Bob']);
        notifier.updateScore(0, 5);
        notifier.updateScore(0, 3);
        notifier.updateScore(1, 10);

        expect(notifier.state.players[0].score, 8);
        expect(notifier.state.players[1].score, 10);
      });
    });

    group('giveYellowCard', () {
      test('increments yellowCards and decrements score by 1', () {
        notifier.setPlayers(['Alice']);
        notifier.giveYellowCard(0);

        expect(notifier.state.players[0].yellowCards, 1);
        expect(notifier.state.players[0].score, -1);
      });

      test('is ignored for invalid player index', () {
        notifier.setPlayers(['Alice']);
        notifier.giveYellowCard(1);

        expect(notifier.state.players[0].yellowCards, 0);
      });

      test('accumulates multiple yellow cards', () {
        notifier.setPlayers(['Alice']);
        notifier.giveYellowCard(0);
        notifier.giveYellowCard(0);

        expect(notifier.state.players[0].yellowCards, 2);
        expect(notifier.state.players[0].score, -2);
      });
    });

    group('giveRedCard', () {
      test('increments redCards and decrements score by 3', () {
        notifier.setPlayers(['Alice']);
        notifier.giveRedCard(0);

        expect(notifier.state.players[0].redCards, 1);
        expect(notifier.state.players[0].score, -3);
      });

      test('is ignored for invalid player index', () {
        notifier.setPlayers(['Alice']);
        notifier.giveRedCard(1);

        expect(notifier.state.players[0].redCards, 0);
      });

      test('accumulates multiple red cards', () {
        notifier.setPlayers(['Alice']);
        notifier.giveRedCard(0);
        notifier.giveRedCard(0);

        expect(notifier.state.players[0].redCards, 2);
        expect(notifier.state.players[0].score, -6);
      });
    });

    group('nextQuestion', () {
      test('advances to next question', () async {
        mockRepo.questions = List.generate(
          3,
          (i) => QuestionModel(id: '$i', type: 'trivia', text: 'Q$i'),
        );

        await notifier.selectGameType('trivia');
        expect(notifier.state.currentQuestionIndex, 0);

        notifier.nextQuestion();
        expect(notifier.state.currentQuestionIndex, 1);

        notifier.nextQuestion();
        expect(notifier.state.currentQuestionIndex, 2);
      });

      test('does not advance past the last question', () async {
        mockRepo.questions = [
          QuestionModel(id: '1', type: 'trivia', text: 'Q1'),
        ];

        await notifier.selectGameType('trivia');
        expect(notifier.state.currentQuestionIndex, 0);

        notifier.nextQuestion();
        expect(notifier.state.currentQuestionIndex, 0);
      });
    });

    group('getRankedPlayers', () {
      test('returns players sorted by score descending', () {
        notifier.setPlayers(['Alice', 'Bob', 'Charlie']);
        notifier.updateScore(0, 10); // Alice
        notifier.updateScore(1, 30); // Bob
        notifier.updateScore(2, 20); // Charlie

        final ranked = notifier.getRankedPlayers();
        expect(ranked[0].name, 'Bob');
        expect(ranked[1].name, 'Charlie');
        expect(ranked[2].name, 'Alice');
      });

      test('original list order is unchanged', () {
        notifier.setPlayers(['Alice', 'Bob', 'Charlie']);
        notifier.updateScore(0, 10); // Alice=10
        notifier.updateScore(1, 30); // Bob=30
        notifier.updateScore(2, 20); // Charlie=20

        notifier.getRankedPlayers();

        expect(notifier.state.players[0].name, 'Alice');
        expect(notifier.state.players[1].name, 'Bob');
        expect(notifier.state.players[2].name, 'Charlie');
      });

      test('returns empty list when no players', () {
        final ranked = notifier.getRankedPlayers();
        expect(ranked, isEmpty);
      });
    });

    group('resetGame', () {
      test('resets state to initial defaults', () {
        notifier.setPlayers(['Alice', 'Bob']);
        notifier.updateScore(0, 100);

        notifier.resetGame();

        expect(notifier.state.players, isEmpty);
        expect(notifier.state.questions, isEmpty);
        expect(notifier.state.selectedCategories, []);
        expect(notifier.state.currentQuestionIndex, 0);
        expect(notifier.state.isLoading, false);
        expect(notifier.state.error, isNull);
      });
    });
  });
}
