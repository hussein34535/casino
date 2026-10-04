import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/data/models/game/player_model.dart';
import 'package:game_show_app/data/models/question/question_model.dart';
import 'package:game_show_app/domain/repositories/game_repository.dart';
import 'package:game_show_app/data/repositories/game_repository_impl.dart';
import 'package:game_show_app/presentation/providers/auth_provider.dart';
import 'package:game_show_app/presentation/providers/infrastructure_provider.dart';
import 'package:game_show_app/presentation/providers/room_provider.dart';

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  return GameRepositoryImpl(
    ref.read(firestoreServiceProvider),
    ref.read(cacheProvider),
  );
});

class GameState {
  final List<LocalPlayer> players;
  final List<QuestionModel> questions;
  final List<String>? selectedCategories;
  final int currentQuestionIndex;
  final bool isLoading;
  final String? error;
  final String? winnerId;
  final bool isBotMode;
  final int? botPlayerIndex;
  final bool isBotThinking;
  final bool? lastBotAnswerCorrect;
  final String? botTaunt;

  const GameState({
    this.players = const [],
    this.questions = const [],
    this.selectedCategories,
    this.currentQuestionIndex = 0,
    this.isLoading = false,
    this.error,
    this.winnerId,
    this.isBotMode = false,
    this.botPlayerIndex,
    this.isBotThinking = false,
    this.lastBotAnswerCorrect,
    this.botTaunt,
  });

  GameState copyWith({
    List<LocalPlayer>? players,
    List<QuestionModel>? questions,
    List<String>? selectedCategories,
    int? currentQuestionIndex,
    bool? isLoading,
    String? error,
    String? winnerId,
    bool? isBotMode,
    int? botPlayerIndex,
    bool? isBotThinking,
    bool? lastBotAnswerCorrect,
    String? botTaunt,
  }) {
    return GameState(
      players: players ?? this.players,
      questions: questions ?? this.questions,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      winnerId: winnerId ?? this.winnerId,
      isBotMode: isBotMode ?? this.isBotMode,
      botPlayerIndex: botPlayerIndex ?? this.botPlayerIndex,
      isBotThinking: isBotThinking ?? this.isBotThinking,
      lastBotAnswerCorrect: lastBotAnswerCorrect,
      botTaunt: botTaunt,
    );
  }

  QuestionModel? get currentQuestion =>
      questions.isNotEmpty && currentQuestionIndex < questions.length
          ? questions[currentQuestionIndex]
          : null;
}

class GameNotifier extends StateNotifier<GameState> {
  final GameRepository _repository;
  final Ref _ref;

  GameNotifier(this._repository, this._ref) : super(const GameState());

  void setPlayers(List<String> names) {
    state = state.copyWith(
      players: names.map((name) => LocalPlayer(name: name)).toList(),
      currentQuestionIndex: 0,
      questions: [],
      selectedCategories: null,
      isBotMode: false,
      botPlayerIndex: null,
    );
  }

  void setPlayersWithBot(String playerName, String botName, String difficulty) {
    final botIndex = 1;
    state = state.copyWith(
      players: [
        LocalPlayer(name: playerName),
        LocalPlayer(name: botName, isBot: true, botDifficulty: difficulty),
      ],
      currentQuestionIndex: 0,
      questions: [],
      selectedCategories: null,
      isBotMode: true,
      botPlayerIndex: botIndex,
    );
  }

  Future<void> initializeGame(List<String> categories) async {
    state = state.copyWith(
      selectedCategories: categories,
      isLoading: true,
      questions: [],
      currentQuestionIndex: 0,
      error: null,
      winnerId: null,
    );

    try {
      final List<QuestionModel> allQuestions = [];
      for (final cat in categories) {
        final catQuestions = await _repository.getQuestions(cat);
        allQuestions.addAll(catQuestions);
      }

      // In an online room every device must show the same question order,
      // so the shuffle is seeded with the room id (the app acts as the host).
      // Local play keeps a fully random order.
      final roomId = _ref.read(currentRoomIdProvider);
      if (roomId != null) {
        allQuestions.shuffle(Random(_stableSeed(roomId)));
      } else {
        allQuestions.shuffle();
      }

      final picked = allQuestions.take(50).toList();

      state = state.copyWith(
        questions: picked,
        isLoading: false,
        currentQuestionIndex: 0,
      );

      // If there's an active room session, sync to Firestore.
      // All clients write identical data, so the write is conflict-free.
      if (roomId != null) {
        await _ref.read(firestoreServiceProvider).updateGameSession(roomId, {
          'currentQuestionIndex': 0,
          'categories': categories,
          'usedQuestionIds': picked.map((q) => q.id).toList(),
        });
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Deterministic 32-bit string hash — stable across devices/VM versions
  /// (unlike String.hashCode).
  static int _stableSeed(String input) {
    var h = 0;
    for (final c in input.codeUnits) {
      h = (h * 31 + c) & 0x7fffffff;
    }
    return h;
  }

  // Legacy support for single category
  Future<void> selectGameType(String type) => initializeGame([type]);

  void updateScore(int playerIndex, int amount) {
    if (playerIndex < 0 || playerIndex >= state.players.length) return;
    final players = [...state.players];
    final newScore = players[playerIndex].score + amount;
    
    players[playerIndex] = LocalPlayer(
      name: players[playerIndex].name,
      score: newScore,
      yellowCards: players[playerIndex].yellowCards,
      redCards: players[playerIndex].redCards,
    );

    String? winnerId;
    if (newScore >= 10) {
      winnerId = players[playerIndex].name; // For local use name
    }

    state = state.copyWith(players: players, winnerId: winnerId);
  }

  /// Updates score for a multiplayer session player in Firestore
  Future<void> updateScoreFirestore(String playerId, int delta) async {
    final roomId = _ref.read(currentRoomIdProvider);
    if (roomId == null) return;
    final firestore = _ref.read(firestoreServiceProvider);
    final doc = await firestore.getGameSession(roomId);
    if (!doc.exists) return;
    final data = doc.data() as Map<String, dynamic>;
    final scores = Map<String, int>.from(
        (data['scores'] as Map<String, dynamic>? ?? {}).map((k, v) => MapEntry(k, (v as num).toInt())));
    
    final newScore = (scores[playerId] ?? 0) + delta;
    scores[playerId] = newScore;
    
    final updates = <String, dynamic>{'scores': scores};
    
    // Check for winner (10 points)
    if (newScore >= 10 && data['winnerId'] == null) {
      updates['winnerId'] = playerId;
      updates['status'] = 'finished';
      updates['endedAt'] = DateTime.now().toIso8601String();
    }
    
    await firestore.updateGameSession(roomId, updates);
  }

  /// Deducts a point for an incorrect answer in Firestore
  Future<void> incorrectAnswerFirestore(String playerId) async {
    final roomId = _ref.read(currentRoomIdProvider);
    if (roomId == null) return;
    final firestore = _ref.read(firestoreServiceProvider);
    final doc = await firestore.getGameSession(roomId);
    if (!doc.exists) return;
    final data = doc.data() as Map<String, dynamic>;
    final scores = Map<String, int>.from(
        (data['scores'] as Map<String, dynamic>? ?? {}).map((k, v) => MapEntry(k, (v as num).toInt())));
    
    scores[playerId] = (scores[playerId] ?? 0) - 1;
    await firestore.updateGameSession(roomId, {'scores': scores});
  }

  /// Claims the buzzer for a player in Online mode
  Future<void> claimBuzzer(String playerId) async {
    final roomId = _ref.read(currentRoomIdProvider);
    if (roomId == null) return;
    await _ref.read(firestoreServiceProvider).updateGameSession(roomId, {
      'buzzerPlayerId': playerId,
    });
  }

  /// Submits an answer in Online mode and validates it
  Future<void> submitAnswerOnline(String playerId, String answer, String correctAnswer) async {
    final roomId = _ref.read(currentRoomIdProvider);
    if (roomId == null) return;
    
    final correct = _isCorrect(answer, correctAnswer);
    final delta = correct ? 1 : -1;
    
    await updateScoreFirestore(playerId, delta);
    
    // Reset buzzer after answer and show answer if correct
    await _ref.read(firestoreServiceProvider).updateGameSession(roomId, {
      'buzzerPlayerId': null,
      'lastAnswer': answer,
      'lastAnswerPlayerId': playerId,
      'isLastAnswerCorrect': correct,
      if (correct) 'showAnswer': true,
    });
  }

  /// Votes to advance to the next question
  Future<void> voteNext() async {
    final roomId = _ref.read(currentRoomIdProvider);
    final userId = _ref.read(authStateProvider).value?.id;
    if (roomId == null || userId == null) return;
    
    final firestore = _ref.read(firestoreServiceProvider);
    final doc = await firestore.getGameSession(roomId);
    if (!doc.exists) return;
    
    final data = doc.data() as Map<String, dynamic>;
    final votes = List<String>.from(data['nextVotes'] ?? []);
    
    if (!votes.contains(userId)) {
      votes.add(userId);
    }
    
    final totalPlayers = (data['players'] as List).length;
    final updates = <String, dynamic>{'nextVotes': votes};
    
    // If everyone voted, advance
    if (votes.length >= totalPlayers) {
      final current = (data['currentQuestionIndex'] as int? ?? 0);
      // Never advance past the last question — the app ends the game itself.
      if (current + 1 <= state.questions.length) {
        updates['currentQuestionIndex'] = current + 1;
      }
      updates['nextVotes'] = []; // reset votes
      updates['buzzerPlayerId'] = null; // reset buzzer
      updates['showAnswer'] = false; // reset answer visibility
      updates['lastAnswer'] = null;
      updates['lastAnswerPlayerId'] = null;
      updates['isLastAnswerCorrect'] = null;
    }
    
    await firestore.updateGameSession(roomId, updates);
  }

  bool _isCorrect(String input, String expected) {
    if (expected.isEmpty) return false;
    
    // Normalize Arabic
    String normalize(String s) {
      return s.toLowerCase()
        .replaceAll(RegExp(r'[أإآ]'), 'ا')
        .replaceAll(RegExp(r'ة'), 'ه')
        .replaceAll(RegExp(r'[ى]'), 'ي')
        .replaceAll(RegExp(r'[^\w\s]'), '') // remove punctuation
        .trim();
    }

    final nInput = normalize(input);
    final nExpected = normalize(expected);

    if (nInput == nExpected) return true;
    if (nInput.contains(nExpected) && nExpected.length > 2) return true;
    if (nExpected.contains(nInput) && nInput.length > 2) return true;
    
    return false;
  }

  /// Advances question index in Firestore (any player — the app is the host)
  Future<void> nextQuestionFirestore() async {
    final roomId = _ref.read(currentRoomIdProvider);
    if (roomId == null) {
      // Local-only mode
      nextQuestion();
      return;
    }
    final firestore = _ref.read(firestoreServiceProvider);
    final doc = await firestore.getGameSession(roomId);
    if (!doc.exists) return;
    final data = doc.data() as Map<String, dynamic>;
    final current = (data['currentQuestionIndex'] as int? ?? 0);
    await firestore.updateGameSession(roomId, {
      'currentQuestionIndex': current + 1,
    });
  }

  void giveYellowCard(int playerIndex) {
    if (playerIndex < 0 || playerIndex >= state.players.length) return;
    final players = [...state.players];
    players[playerIndex] = LocalPlayer(
      name: players[playerIndex].name,
      score: players[playerIndex].score - 1,
      yellowCards: players[playerIndex].yellowCards + 1,
      redCards: players[playerIndex].redCards,
    );
    state = state.copyWith(players: players);
  }

  void giveRedCard(int playerIndex) {
    if (playerIndex < 0 || playerIndex >= state.players.length) return;
    final players = [...state.players];
    players[playerIndex] = LocalPlayer(
      name: players[playerIndex].name,
      score: players[playerIndex].score - 3,
      yellowCards: players[playerIndex].yellowCards,
      redCards: players[playerIndex].redCards + 1,
    );
    state = state.copyWith(players: players);
  }

  void nextQuestion() {
    if (state.currentQuestionIndex < state.questions.length - 1) {
      state = state.copyWith(currentQuestionIndex: state.currentQuestionIndex + 1);
    }
  }

  List<LocalPlayer> getRankedPlayers() {
    final sorted = List<LocalPlayer>.from(state.players);
    sorted.sort((a, b) => b.score.compareTo(a.score));
    return sorted;
  }

  List<LocalPlayer> get players => state.players;

  /// Bot answers the current question. Returns after a delay.
  /// [playerAnswerCorrect] is whether the human player answered correctly.
  Future<void> botAnswerQuestion({required bool playerAnswerCorrect}) async {
    if (!state.isBotMode || state.botPlayerIndex == null) return;

    final botIndex = state.botPlayerIndex!;
    final bot = state.players[botIndex];
    if (!bot.isBot || bot.botDifficulty == null) return;

    // Show thinking state
    state = state.copyWith(isBotThinking: true, lastBotAnswerCorrect: null, botTaunt: null);

    // Simulate response time (0.5s - 2s)
    final delay = Duration(milliseconds: 500 + (DateTime.now().millisecond % 1500));
    await Future.delayed(delay);

    // Determine if bot answers correctly based on difficulty
    final difficulty = bot.botDifficulty!;
    final random = DateTime.now().microsecondsSinceEpoch;
    double accuracy;
    switch (difficulty) {
      case 'easy':
        accuracy = 0.3;
        break;
      case 'medium':
        accuracy = 0.6;
        break;
      case 'hard':
        accuracy = 0.85;
        break;
      case 'elon':
        accuracy = 0.95;
        break;
      default:
        accuracy = 0.5;
    }

    // If human answered correctly, bot has slightly lower chance (competitive balance)
    if (playerAnswerCorrect) {
      accuracy = (accuracy - 0.1).clamp(0.0, 1.0);
    }

    final botCorrect = (random % 100) < (accuracy * 100);

    // Update bot score
    if (botCorrect) {
      updateScore(botIndex, 1);
    }

    // Get taunt
    final taunt = _getBotTaunt(difficulty, botCorrect);

    // Update state with result
    state = state.copyWith(
      isBotThinking: false,
      lastBotAnswerCorrect: botCorrect,
      botTaunt: taunt,
    );

    // Auto-clear taunt after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        state = state.copyWith(lastBotAnswerCorrect: null, botTaunt: null);
      }
    });
  }

  String _getBotTaunt(String difficulty, bool correct) {
    final easyTaunts = correct
        ? ['Easy peasy!', 'Is that all?', 'Try harder!']
        : ['Oops!', 'Tricky one!', 'Hmm...'];
    final mediumTaunts = correct
        ? ['Not bad...', 'Getting interesting!', "You're good!"]
        : ['Lucky!', 'I need more study!', 'Next time!'];
    final hardTaunts = correct
        ? ['Impressive!', 'A worthy opponent!', 'Finally a challenge!']
        : ['Even I slip!', 'That was close!', 'Rematch?'];
    final elonTaunts = correct
        ? ['Let that sink in!', 'Amazing!', 'My Boring Company > your knowledge']
        : ['Mars is harder!', 'Innovation takes risks!', 'Back to the drawing board!'];

    final pool = switch (difficulty) {
      'easy' => easyTaunts,
      'medium' => mediumTaunts,
      'hard' => hardTaunts,
      'elon' => elonTaunts,
      _ => mediumTaunts,
    };

    final idx = DateTime.now().microsecondsSinceEpoch % pool.length;
    return pool[idx];
  }

  void resetGame() {
    state = const GameState();
  }
}

final gameStateProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier(ref.read(gameRepositoryProvider), ref);
});

/// Provides synced question index from Firestore when in a multiplayer room.
/// Falls back to local game state index when playing solo.
final syncedQuestionIndexProvider = Provider<int>((ref) {
  final roomSession = ref.watch(roomSessionStreamProvider).valueOrNull;
  if (roomSession != null) {
    return roomSession.currentQuestionIndex;
  }
  return ref.watch(gameStateProvider).currentQuestionIndex;
});

/// Provides live player scores from Firestore when in multiplayer mode.
final syncedPlayersProvider = Provider<List<PlayerModel>>((ref) {
  final session = ref.watch(roomSessionStreamProvider).valueOrNull;
  if (session == null) return [];
  // Merge scores from session.scores map into player objects
  return session.players.map((p) {
    return PlayerModel(
      id: p.id,
      name: p.name,
      photoUrl: p.photoUrl,
      isHost: p.isHost,
      score: session.scores[p.id] ?? 0,
    );
  }).toList()
    ..sort((a, b) => b.score.compareTo(a.score));
});
