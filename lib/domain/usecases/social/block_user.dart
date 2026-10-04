import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/domain/repositories/social_repository.dart';

class BlockUser {
  final SocialRepository socialRepository;

  const BlockUser(this.socialRepository);

  Future<void> call(String userId, String blockedId) async {
    try {
      return await socialRepository.blockUser(userId, blockedId);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
