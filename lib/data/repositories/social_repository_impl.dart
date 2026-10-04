import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_show_app/data/models/user/user_model.dart';
import 'package:game_show_app/domain/repositories/social_repository.dart';
import 'package:game_show_app/services/firebase/firestore_service.dart';

class SocialRepositoryImpl implements SocialRepository {
  final FirestoreService _firestoreService;

  SocialRepositoryImpl(this._firestoreService);

  @override
  Stream<List<UserModel>> getFriends(String userId) {
    return _firestoreService.getFriends(userId).map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return UserModel.fromJson(data);
          })
          .toList();
    });
  }

  @override
  Future<void> sendFriendRequest(String fromId, String toId) async {
    await _firestoreService.sendFriendRequest(fromId, toId);
  }

  @override
  Future<void> acceptFriendRequest(String docId) async {
    await _firestoreService.acceptFriendRequest(docId);
  }

  @override
  Future<void> rejectFriendRequest(String docId) async {
    final doc = await _firestoreService.getFriendRequest(docId);
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      await _firestoreService.deleteFriendRequest(
        data['userId'] as String,
        data['friendId'] as String,
      );
    }
  }

  @override
  Future<void> blockUser(String userId, String blockedId) async {
    await _firestoreService.updateUser(userId, {
      'blockedUsers': FieldValue.arrayUnion([blockedId]),
    });
  }

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    if (query.trim().isEmpty) return [];
    try {
      final snapshot = await _firestoreService.searchUsers(query.trim());
      return snapshot.docs.map((doc) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (_) {
      return [];
    }
  }
}
