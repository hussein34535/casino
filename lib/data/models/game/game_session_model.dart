import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_show_app/data/models/game/player_model.dart';

class GameSessionModel {
  final String id;
  final String hostId;
  final String roomCode;
  final List<String> categories;
  String status;
  List<PlayerModel> players;
  /// Flat uid list kept in sync with [players] for security rules.
  List<String> playerIds;
  int currentQuestionIndex;
  int maxQuestions;
  int roundTime;
  int maxPlayers;
  bool isPublic;
  String? winnerId;
  DateTime? startedAt;
  DateTime? endedAt;
  DateTime createdAt;
  List<String> usedQuestionIds;
  Map<String, int> scores;
  String? buzzerPlayerId;
  List<String> nextVotes;
  bool showAnswer;
  String? lastAnswer;
  String? lastAnswerPlayerId;
  bool? isLastAnswerCorrect;

  GameSessionModel({
    required this.id,
    required this.hostId,
    required this.roomCode,
    required this.categories,
    this.status = 'waiting',
    List<PlayerModel>? players,
    List<String>? playerIds,
    this.currentQuestionIndex = 0,
    this.maxQuestions = 20,
    this.roundTime = 30,
    this.maxPlayers = 10,
    this.isPublic = false,
    this.winnerId,
    this.startedAt,
    this.endedAt,
    DateTime? createdAt,
    List<String>? usedQuestionIds,
    Map<String, int>? scores,
    this.buzzerPlayerId,
    List<String>? nextVotes,
    this.showAnswer = false,
    this.lastAnswer,
    this.lastAnswerPlayerId,
    this.isLastAnswerCorrect,
  }) : players = players ?? [],
        playerIds = playerIds ?? players?.map((p) => p.id).toList() ?? [],
       usedQuestionIds = usedQuestionIds ?? [],
       scores = scores ?? {},
       nextVotes = nextVotes ?? [],
       createdAt = createdAt ?? DateTime.now();

  factory GameSessionModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      return null;
    }

    return GameSessionModel(
      id: json['id'] as String? ?? '',
      hostId: json['hostId'] as String? ?? '',
      roomCode: json['roomCode'] as String? ?? '',
      categories: (json['categories'] as List<dynamic>?)?.cast<String>() ?? ['trivia'],
      status: json['status'] as String? ?? 'waiting',
      players: (json['players'] as List<dynamic>?)
          ?.map((p) => PlayerModel.fromJson(p as Map<String, dynamic>))
          .toList() ?? [],
      playerIds: (json['playerIds'] as List<dynamic>?)?.cast<String>() ??
          (json['players'] as List<dynamic>?)
              ?.map((p) => (p as Map<String, dynamic>)['id'] as String? ?? '')
              .toList() ??
          [],
      currentQuestionIndex: json['currentQuestionIndex'] as int? ?? 0,
      maxQuestions: json['maxQuestions'] as int? ?? 20,
      roundTime: json['roundTime'] as int? ?? 30,
      maxPlayers: json['maxPlayers'] as int? ?? 10,
      isPublic: json['isPublic'] as bool? ?? false,
      winnerId: json['winnerId'] as String?,
      startedAt: parseDate(json['startedAt']),
      endedAt: parseDate(json['endedAt']),
      createdAt: parseDate(json['createdAt']) ?? DateTime.now(),
      usedQuestionIds: (json['usedQuestionIds'] as List<dynamic>?)?.cast<String>() ?? [],
      scores: (json['scores'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v as int)) ?? const {},
      buzzerPlayerId: json['buzzerPlayerId'] as String?,
      nextVotes: (json['nextVotes'] as List<dynamic>?)?.cast<String>() ?? [],
      showAnswer: json['showAnswer'] as bool? ?? false,
      lastAnswer: json['lastAnswer'] as String?,
      lastAnswerPlayerId: json['lastAnswerPlayerId'] as String?,
      isLastAnswerCorrect: json['isLastAnswerCorrect'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'hostId': hostId,
    'roomCode': roomCode,
    'categories': categories,
    'status': status,
    'players': players.map((p) => p.toJson()).toList(),
    'playerIds': playerIds,
    'currentQuestionIndex': currentQuestionIndex,
    'maxQuestions': maxQuestions,
    'roundTime': roundTime,
    'maxPlayers': maxPlayers,
    'isPublic': isPublic,
    'winnerId': winnerId,
    'startedAt': startedAt,
    'endedAt': endedAt,
    'createdAt': createdAt,
    'usedQuestionIds': usedQuestionIds,
    'scores': scores,
    'buzzerPlayerId': buzzerPlayerId,
    'nextVotes': nextVotes,
    'showAnswer': showAnswer,
    'lastAnswer': lastAnswer,
    'lastAnswerPlayerId': lastAnswerPlayerId,
    'isLastAnswerCorrect': isLastAnswerCorrect,
  };
}
