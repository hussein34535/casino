import 'dart:async';
import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/data/models/user/user_model.dart';
import 'package:game_show_app/domain/repositories/social_repository.dart';

class GetFriends {
  final SocialRepository socialRepository;

  const GetFriends(this.socialRepository);

  Stream<List<UserModel>> call(String userId) {
    try {
      return socialRepository.getFriends(userId);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
