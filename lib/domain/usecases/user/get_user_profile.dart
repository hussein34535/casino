import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/data/models/user/user_model.dart';
import 'package:game_show_app/domain/repositories/user_repository.dart';

class GetUserProfile {
  final UserRepository userRepository;

  const GetUserProfile(this.userRepository);

  Future<UserModel> call(String uid) async {
    try {
      return await userRepository.getUserProfile(uid);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
