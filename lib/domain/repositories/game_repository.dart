import 'package:game_show_app/data/models/game/game_session_model.dart';
import 'package:game_show_app/data/models/game/player_model.dart';
import 'package:game_show_app/data/models/question/question_model.dart';

abstract class GameRepository {
  Future<List<QuestionModel>> getQuestions(String type, {String? difficulty, int limit});
  Future<String> createSession(GameSessionModel session);
  Future<void> updateSession(String id, Map<String, dynamic> data);
  Stream<GameSessionModel?> sessionStream(String id);
  Future<void> submitAnswer(String sessionId, String playerId, String questionId, String answer);
  Future<List<PlayerModel>> getSessionPlayers(String sessionId);
}
