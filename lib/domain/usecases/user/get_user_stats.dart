import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/domain/repositories/user_repository.dart';

class GetUserStats {
  final UserRepository userRepository;

  const GetUserStats(this.userRepository);

  Future<Map<String, dynamic>> call(String uid) async {
    try {
      final user = await userRepository.getUserProfile(uid);
      return {
        'gamesPlayed': user.gamesPlayed,
        'gamesWon': user.gamesWon,
        'winRate': user.winRate,
        'xp': user.xp,
        'level': user.level,
        'streak': user.streak,
        'coins': user.coins,
      };
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
