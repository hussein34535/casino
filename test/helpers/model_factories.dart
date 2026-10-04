import 'package:game_show_app/data/models/user/user_model.dart';
import 'package:game_show_app/data/models/game/game_session_model.dart';
import 'package:game_show_app/data/models/game/player_model.dart';
import 'package:game_show_app/data/models/question/question_model.dart';

UserModel createTestUser({
  String? id,
  String? email,
  String? displayName,
  String? photoUrl,
  String language = 'ar',
  int xp = 100,
  int level = 1,
  int gamesPlayed = 0,
  int gamesWon = 0,
  int totalScore = 0,
  int streak = 0,
  int coins = 0,
  bool isPremium = false,
  bool isAdmin = false,
  bool isBanned = false,
  bool emailVerified = false,
  DateTime? lastActiveAt,
  DateTime? createdAt,
  List<String>? friends,
  List<String>? blockedUsers,
  Map<String, dynamic>? settings,
}) {
  return UserModel(
    id: id ?? 'test_user_id',
    email: email ?? 'test@example.com',
    displayName: displayName ?? 'Test User',
    photoUrl: photoUrl,
    language: language,
    xp: xp,
    level: level,
    gamesPlayed: gamesPlayed,
    gamesWon: gamesWon,
    totalScore: totalScore,
    streak: streak,
    coins: coins,
    isPremium: isPremium,
    isAdmin: isAdmin,
    isBanned: isBanned,
    emailVerified: emailVerified,
    lastActiveAt: lastActiveAt,
    createdAt: createdAt,
    friends: friends,
    blockedUsers: blockedUsers,
    settings: settings,
  );
}

GameSessionModel createTestSession({
  String? id,
  String? hostId,
  String? roomCode,
  List<String>? categories,
  String status = 'waiting',
  List<PlayerModel>? players,
  int currentQuestionIndex = 0,
  int maxQuestions = 20,
  int roundTime = 30,
  bool isPublic = false,
  String? winnerId,
  DateTime? startedAt,
  DateTime? endedAt,
  DateTime? createdAt,
  List<String>? usedQuestionIds,
  Map<String, int>? scores,
}) {
  return GameSessionModel(
    id: id ?? 'test_session_id',
    hostId: hostId ?? 'test_host_id',
    roomCode: roomCode ?? 'ROOM1',
    categories: categories ?? ['trivia'],
    status: status,
    players: players,
    currentQuestionIndex: currentQuestionIndex,
    maxQuestions: maxQuestions,
    roundTime: roundTime,
    isPublic: isPublic,
    winnerId: winnerId,
    startedAt: startedAt,
    endedAt: endedAt,
    createdAt: createdAt,
    usedQuestionIds: usedQuestionIds,
    scores: scores,
  );
}

QuestionModel createTestQuestion({
  String? id,
  String? type,
  String? text,
  String? answer,
  String? audioUrl,
  String? singerName,
  String? songName,
  String? imageUrl,
  String? category,
  String difficulty = 'easy',
  bool isActive = true,
  int timesUsed = 0,
  String? createdBy,
  int reportCount = 0,
  bool isApproved = true,
  int points = 0,
}) {
  return QuestionModel(
    id: id ?? 'test_q_id',
    type: type ?? 'trivia',
    text: text ?? 'Test question?',
    answer: answer ?? 'Test answer',
    audioUrl: audioUrl,
    singerName: singerName,
    songName: songName,
    imageUrl: imageUrl,
    category: category,
    difficulty: difficulty,
    isActive: isActive,
    timesUsed: timesUsed,
    createdBy: createdBy,
    reportCount: reportCount,
    isApproved: isApproved,
    points: points,
  );
}

List<QuestionModel> createTestQuestionList({
  String type = 'trivia',
  String difficulty = 'easy',
  int count = 5,
}) {
  return List.generate(count, (i) => createTestQuestion(
    id: 'q${i + 1}',
    type: type,
    text: 'Test question ${i + 1}',
    answer: 'Answer ${i + 1}',
    difficulty: difficulty,
  ));
}

PlayerModel createTestPlayerModel({
  String? id,
  String? name,
  int score = 0,
  int yellowCards = 0,
  int redCards = 0,
  String? userId,
  bool isOnline = false,
  String? avatarUrl,
}) {
  return PlayerModel(
    id: id ?? 'test_player_id',
    name: name ?? 'Test Player',
    score: score,
    yellowCards: yellowCards,
    redCards: redCards,
    userId: userId,
    isOnline: isOnline,
    avatarUrl: avatarUrl,
  );
}

LocalPlayer createTestLocalPlayer({
  String? name,
  int score = 0,
  int yellowCards = 0,
  int redCards = 0,
}) {
  return LocalPlayer(
    name: name ?? 'Test Local Player',
    score: score,
    yellowCards: yellowCards,
    redCards: redCards,
  );
}
