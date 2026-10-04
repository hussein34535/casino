import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/domain/repositories/social_repository.dart';

class RejectFriendRequest {
  final SocialRepository socialRepository;

  const RejectFriendRequest(this.socialRepository);

  Future<void> call(String docId) async {
    try {
      return await socialRepository.rejectFriendRequest(docId);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
