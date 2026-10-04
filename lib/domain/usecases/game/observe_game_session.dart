import 'package:game_show_app/data/models/game/game_session_model.dart';
import 'package:game_show_app/domain/repositories/game_repository.dart';

class ObserveGameSession {
  final GameRepository _repository;

  ObserveGameSession(this._repository);

  Stream<GameSessionModel?> call(String id) {
    return _repository.sessionStream(id);
  }
}
