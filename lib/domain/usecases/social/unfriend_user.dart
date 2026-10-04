import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/domain/repositories/social_repository.dart';

class UnfriendUser {
  final SocialRepository socialRepository;

  const UnfriendUser(this.socialRepository);

  Future<void> call(String userId, String friendId) async {
    try {
      await socialRepository.blockUser(userId, friendId);
      await socialRepository.blockUser(friendId, userId);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
