import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/data/models/game/game_session_model.dart';
import 'package:game_show_app/domain/repositories/game_repository.dart';

class CreateGameSession {
  final GameRepository _repository;

  CreateGameSession(this._repository);

  Future<String> call(GameSessionModel session) async {
    try {
      return await _repository.createSession(session);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
