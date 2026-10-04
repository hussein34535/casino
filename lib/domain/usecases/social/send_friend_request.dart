import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/domain/repositories/social_repository.dart';

class SendFriendRequest {
  final SocialRepository socialRepository;

  const SendFriendRequest(this.socialRepository);

  Future<void> call(String fromId, String toId) async {
    try {
      return await socialRepository.sendFriendRequest(fromId, toId);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
