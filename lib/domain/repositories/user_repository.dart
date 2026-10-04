import 'package:game_show_app/data/models/user/user_model.dart';
import 'package:game_show_app/data/models/leaderboard/leaderboard_model.dart';
import 'package:game_show_app/data/models/achievement/achievement_model.dart';

abstract class UserRepository {
  Future<UserModel> getUserProfile(String uid);
  Future<void> updateProfile(String uid, Map<String, dynamic> data);
  Future<void> uploadAvatar(String uid, String filePath);
  Future<List<LeaderboardEntry>> getLeaderboard({String period = 'weekly'});
  Future<List<AchievementModel>> getAchievements();
  Future<List<UserAchievement>> getUserAchievements(String userId);
  Future<void> addXp(String uid, int amount);
  Future<void> addCoins(String uid, int amount);
  Future<void> addItemToInventory(String userId, String itemId);
  Future<List<String>> getInventory(String userId);
  Future<bool> equipItem(String userId, String itemId);
}
