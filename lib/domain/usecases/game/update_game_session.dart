import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/domain/repositories/game_repository.dart';

class UpdateGameSession {
  final GameRepository _repository;

  UpdateGameSession(this._repository);

  Future<void> call({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      return await _repository.updateSession(id, data);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
