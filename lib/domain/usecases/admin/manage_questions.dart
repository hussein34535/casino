import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/domain/repositories/game_repository.dart';

class ManageQuestions {
  final GameRepository gameRepository;

  ManageQuestions(this.gameRepository);

  Future<void> approveQuestion(String id) async {
    try {
      await gameRepository.updateSession(id, {'approved': true});
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  Future<void> rejectQuestion(String id, String reason) async {
    try {
      await gameRepository.updateSession(id, {'approved': false, 'rejectionReason': reason});
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  Future<void> deleteQuestion(String id) async {
    try {
      await gameRepository.updateSession(id, {'deleted': true});
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  Future<void> createQuestion(Map<String, dynamic> data) async {
    try {
      await gameRepository.createSession(data as dynamic);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
