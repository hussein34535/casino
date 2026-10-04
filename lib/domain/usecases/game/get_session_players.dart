import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/data/models/game/player_model.dart';
import 'package:game_show_app/domain/repositories/game_repository.dart';

class GetSessionPlayers {
  final GameRepository _repository;

  GetSessionPlayers(this._repository);

  Future<List<PlayerModel>> call(String sessionId) async {
    try {
      return await _repository.getSessionPlayers(sessionId);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
