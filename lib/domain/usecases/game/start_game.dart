import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/domain/repositories/game_repository.dart';

class StartGame {
  final GameRepository _repository;

  StartGame(this._repository);

  Future<void> call(String id) async {
    try {
      return await _repository.updateSession(id, {
        'status': 'started',
        'startedAt': FieldValue.serverTimestamp(),
      });
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
