import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/domain/repositories/game_repository.dart';

class SubmitAnswer {
  final GameRepository _repository;

  SubmitAnswer(this._repository);

  Future<void> call({
    required String sessionId,
    required String playerId,
    required String questionId,
    required String answer,
  }) async {
    try {
      return await _repository.submitAnswer(sessionId, playerId, questionId, answer);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
