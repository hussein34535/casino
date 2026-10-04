import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/data/models/user/user_model.dart';
import 'package:game_show_app/data/models/achievement/achievement_model.dart';
import 'package:game_show_app/data/models/leaderboard/leaderboard_model.dart';
import 'package:game_show_app/domain/usecases/user/get_user_profile.dart';
import 'package:game_show_app/domain/repositories/user_repository.dart';

class MockUserRepo implements UserRepository {
  UserModel? mockUser;
  bool shouldThrow = false;
  bool userNotFound = false;

  @override
  Future<UserModel> getUserProfile(String uid) async {
    if (shouldThrow) throw Exception('Repo error');
    if (userNotFound || mockUser == null) throw Exception('User not found');
    return mockUser!;
  }

  @override
  Future<void> updateProfile(String uid, Map<String, dynamic> data) async {}

  @override
  Future<void> uploadAvatar(String uid, String filePath) async {}

  @override
  Future<List<LeaderboardEntry>> getLeaderboard({String period = 'weekly'}) async => [];

  @override
  Future<List<AchievementModel>> getAchievements() async => [];

  @override
  Future<List<UserAchievement>> getUserAchievements(String userId) async => [];

  @override
  Future<void> addXp(String uid, int amount) async {}

  @override
  Future<void> addCoins(String uid, int amount) async {}

  @override
  Future<void> addItemToInventory(String userId, String itemId) async {}

  @override
  Future<List<String>> getInventory(String userId) async => [];

  @override
  Future<bool> equipItem(String userId, String itemId) async => true;
}

void main() {
  group('GetUserProfile', () {
    late MockUserRepo mockRepo;
    late GetUserProfile useCase;

    setUp(() {
      mockRepo = MockUserRepo();
      useCase = GetUserProfile(mockRepo);
    });

    test('returns user profile for valid uid', () async {
      mockRepo.mockUser = UserModel(
        id: 'user1',
        email: 'test@example.com',
        displayName: 'Test User',
        xp: 500,
        level: 5,
      );

      final user = await useCase.call('user1');
      expect(user.id, 'user1');
      expect(user.email, 'test@example.com');
      expect(user.displayName, 'Test User');
      expect(user.xp, 500);
      expect(user.level, 5);
    });

    test('throws ServerFailure when user not found', () async {
      mockRepo.userNotFound = true;
      expect(
        () => useCase.call('nonexistent'),
        throwsA(isA<ServerFailure>()),
      );
    });

    test('throws ServerFailure on repository error', () async {
      mockRepo.shouldThrow = true;
      expect(
        () => useCase.call('user1'),
        throwsA(isA<ServerFailure>()),
      );
    });

    test('returns correct profile data', () async {
      mockRepo.mockUser = UserModel(
        id: 'user2',
        email: 'alice@example.com',
        displayName: 'Alice',
        xp: 1000,
        level: 10,
        gamesPlayed: 50,
        gamesWon: 30,
        coins: 2000,
      );

      final user = await useCase.call('user2');
      expect(user.email, 'alice@example.com');
      expect(user.displayName, 'Alice');
      expect(user.gamesPlayed, 50);
      expect(user.gamesWon, 30);
      expect(user.coins, 2000);
    });
  });
}
