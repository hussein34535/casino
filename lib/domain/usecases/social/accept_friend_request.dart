import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/domain/repositories/social_repository.dart';

class AcceptFriendRequest {
  final SocialRepository socialRepository;

  const AcceptFriendRequest(this.socialRepository);

  Future<void> call(String docId) async {
    try {
      return await socialRepository.acceptFriendRequest(docId);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
