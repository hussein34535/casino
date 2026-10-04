import 'package:game_show_app/data/models/user/user_model.dart';

abstract class SocialRepository {
  Stream<List<UserModel>> getFriends(String userId);
  Future<void> sendFriendRequest(String fromId, String toId);
  Future<void> acceptFriendRequest(String docId);
  Future<void> rejectFriendRequest(String docId);
  Future<void> blockUser(String userId, String blockedId);
  Future<List<UserModel>> searchUsers(String query);
}
