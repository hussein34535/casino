import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_show_app/core/infrastructure/cache_manager.dart';
import 'package:game_show_app/core/utils/app_logger.dart';
import 'package:game_show_app/data/models/achievement/achievement_model.dart';
import 'package:game_show_app/data/models/leaderboard/leaderboard_model.dart';
import 'package:game_show_app/data/models/user/user_model.dart';
import 'package:game_show_app/domain/repositories/user_repository.dart';
import 'package:game_show_app/services/firebase/firestore_service.dart';
import 'package:game_show_app/services/firebase/storage_service.dart';

class UserRepositoryImpl implements UserRepository {
  final FirestoreService _firestoreService;
  final StorageService _storageService;
  final CacheManager _cacheManager;

  UserRepositoryImpl(this._firestoreService, this._storageService, this._cacheManager);

  @override
  Future<UserModel> getUserProfile(String uid) async {
    final cacheKey = 'user_profile_$uid';

    final cached = _cacheManager.get<UserModel>(cacheKey);
    if (cached != null) {
      AppLogger.debug('Cache hit for user profile: $uid');
      return cached;
    }

    final doc = await _firestoreService.getUser(uid);
    if (!doc.exists) throw Exception('User not found');
    final user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
    _cacheManager.set<UserModel>(cacheKey, user);
    return user;
  }

  @override
  Future<void> updateProfile(String uid, Map<String, dynamic> data) async {
    await _firestoreService.updateUser(uid, data);
  }

  @override
  Future<void> uploadAvatar(String uid, String filePath) async {
    final url = await _storageService.uploadAvatar(uid, File(filePath));
    await _firestoreService.updateUser(uid, {'photoUrl': url});
  }

  @override
  Future<List<LeaderboardEntry>> getLeaderboard({String period = 'weekly'}) async {
    final snapshot = await _firestoreService
        .getLeaderboard(period: period)
        .first;
    return snapshot.docs
        .map((doc) =>
            LeaderboardEntry.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<AchievementModel>> getAchievements() async {
    final docs = await _firestoreService.getAchievements();
    return docs
        .map((doc) =>
            AchievementModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<UserAchievement>> getUserAchievements(String userId) async {
    final docs = await _firestoreService.getUserAchievements(userId);
    return docs
        .map((doc) =>
            UserAchievement.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addXp(String uid, int amount) async {
    final user = await getUserProfile(uid);
    final newXp = user.xp + amount;
    final newLevel = (newXp / 100).floor() + 1;
    await _firestoreService.updateUser(uid, {
      'xp': newXp,
      'level': newLevel,
    });
  }

  @override
  Future<void> addCoins(String uid, int amount) async {
    await _firestoreService.updateUser(uid, {
      'coins': FieldValue.increment(amount),
    });
  }

  @override
  Future<void> addItemToInventory(String userId, String itemId) async {
    await _firestoreService.updateUser(userId, {
      'inventory': FieldValue.arrayUnion([itemId]),
    });
  }

  @override
  Future<List<String>> getInventory(String userId) async {
    final doc = await _firestoreService.getUser(userId);
    if (!doc.exists) return [];
    final data = doc.data() as Map<String, dynamic>;
    return List<String>.from(data['inventory'] as List? ?? []);
  }

  @override
  Future<bool> equipItem(String userId, String itemId) async {
    await _firestoreService.updateUser(userId, {
      'equipped': itemId,
    });
    return true;
  }
}
