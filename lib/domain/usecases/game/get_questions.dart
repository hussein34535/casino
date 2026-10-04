import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/data/models/question/question_model.dart';
import 'package:game_show_app/domain/repositories/game_repository.dart';

class GetQuestions {
  final GameRepository _repository;

  GetQuestions(this._repository);

  Future<List<QuestionModel>> call({
    required String type,
    String? difficulty,
    int limit = 10,
  }) async {
    try {
      return await _repository.getQuestions(type, difficulty: difficulty, limit: limit);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
