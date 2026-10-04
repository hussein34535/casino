import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/data/models/leaderboard/leaderboard_model.dart';
import 'package:game_show_app/domain/repositories/user_repository.dart';

class GetLeaderboard {
  final UserRepository userRepository;

  const GetLeaderboard(this.userRepository);

  Future<List<LeaderboardEntry>> call({String period = 'weekly'}) async {
    try {
      return await userRepository.getLeaderboard(period: period);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
