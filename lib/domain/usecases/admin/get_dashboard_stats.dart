import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/domain/repositories/game_repository.dart';
import 'package:game_show_app/domain/repositories/user_repository.dart';

class GetDashboardStats {
  final UserRepository userRepository;
  final GameRepository gameRepository;

  GetDashboardStats({
    required this.userRepository,
    required this.gameRepository,
  });

  Future<Map<String, dynamic>> call() async {
    try {
      final totalUsers = await userRepository.getLeaderboard();
      return {
        'totalUsers': totalUsers.length,
        'totalGames': 0,
        'activeUsers': 0,
        'reportsCount': 0,
      };
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
