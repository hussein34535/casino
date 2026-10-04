import 'package:game_show_app/data/models/user/user_model.dart';
import 'package:game_show_app/data/models/game/game_session_model.dart';
import 'package:game_show_app/data/models/game/player_model.dart';
import 'package:game_show_app/data/models/question/question_model.dart';

UserModel createTestUser({
  String? id,
  String? email,
  String? displayName,
  int xp = 100,
  int level = 1,
  int gamesPlayed = 0,
  int gamesWon = 0,
  int coins = 0,
}) {
  return UserModel(
    id: id ?? 'test_user_id',
    email: email ?? 'test@example.com',
    displayName: displayName ?? 'Test User',
    xp: xp,
    level: level,
    gamesPlayed: gamesPlayed,
    gamesWon: gamesWon,
    coins: coins,
  );
}

GameSessionModel createTestGame({
  String? id,
  String? hostId,
  String? roomCode,
  List<String>? categories,
  String status = 'waiting',
  List<PlayerModel>? players,
}) {
  return GameSessionModel(
    id: id ?? 'test_game_id',
    hostId: hostId ?? 'test_host_id',
    roomCode: roomCode ?? 'ROOM1',
    categories: categories ?? ['trivia'],
    status: status,
    players: players ?? [],
  );
}

List<QuestionModel> createTestQuestions({
  String type = 'trivia',
  String difficulty = 'easy',
  int count = 3,
}) {
  return List.generate(count, (i) {
    return QuestionModel(
      id: 'q${i + 1}',
      type: type,
      text: 'Test question ${i + 1}',
      answer: 'Answer ${i + 1}',
      difficulty: difficulty,
    );
  });
}

PlayerModel createTestPlayer({
  String? id,
  String? name,
  int score = 0,
}) {
  return PlayerModel(
    id: id ?? 'test_player_id',
    name: name ?? 'Test Player',
    score: score,
  );
}
