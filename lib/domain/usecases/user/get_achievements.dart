import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/data/models/achievement/achievement_model.dart';
import 'package:game_show_app/domain/repositories/user_repository.dart';

class GetAchievements {
  final UserRepository userRepository;

  const GetAchievements(this.userRepository);

  Future<List<AchievementModel>> call() async {
    try {
      return await userRepository.getAchievements();
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
