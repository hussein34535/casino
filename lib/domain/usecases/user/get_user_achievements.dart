import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/data/models/achievement/achievement_model.dart';
import 'package:game_show_app/domain/repositories/user_repository.dart';

class GetUserAchievements {
  final UserRepository userRepository;

  const GetUserAchievements(this.userRepository);

  Future<List<UserAchievement>> call(String userId) async {
    try {
      return await userRepository.getUserAchievements(userId);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
