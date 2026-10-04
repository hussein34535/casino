import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/domain/repositories/game_repository.dart';

class EndGame {
  final GameRepository _repository;

  EndGame(this._repository);

  Future<void> call({
    required String id,
    required String winnerId,
  }) async {
    try {
      return await _repository.updateSession(id, {
        'status': 'ended',
        'endedAt': FieldValue.serverTimestamp(),
        'winnerId': winnerId,
      });
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
