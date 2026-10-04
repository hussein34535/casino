import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/data/models/user/user_model.dart';
import 'package:game_show_app/data/models/achievement/achievement_model.dart';
import 'package:game_show_app/data/models/leaderboard/leaderboard_model.dart';
import 'package:game_show_app/domain/usecases/user/add_coins.dart';
import 'package:game_show_app/domain/repositories/user_repository.dart';

class MockUserRepo implements UserRepository {
  int? addedCoins;
  bool shouldThrow = false;

  @override
  Future<void> addCoins(String uid, int amount) async {
    if (shouldThrow) throw Exception('Repo error');
    addedCoins = amount;
  }

  @override
  Future<UserModel> getUserProfile(String uid) async => throw UnimplementedError();

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
  Future<void> addItemToInventory(String userId, String itemId) async {}

  @override
  Future<List<String>> getInventory(String userId) async => [];

  @override
  Future<bool> equipItem(String userId, String itemId) async => true;
}

void main() {
  group('AddCoins', () {
    late MockUserRepo mockRepo;
    late AddCoins useCase;

    setUp(() {
      mockRepo = MockUserRepo();
      useCase = AddCoins(mockRepo);
    });

    test('adds positive coin amount', () async {
      await useCase.call('user1', 500);
      expect(mockRepo.addedCoins, 500);
    });

    test('rejects negative amount with ValidationFailure', () async {
      expect(
        () => useCase.call('user1', -100),
        throwsA(isA<ValidationFailure>()),
      );
      expect(mockRepo.addedCoins, isNull);
    });

    test('rejects zero amount with ValidationFailure', () async {
      expect(
        () => useCase.call('user1', 0),
        throwsA(isA<ValidationFailure>()),
      );
      expect(mockRepo.addedCoins, isNull);
    });

    test('throws ServerFailure when repository fails', () async {
      mockRepo.shouldThrow = true;
      expect(
        () => useCase.call('user1', 100),
        throwsA(isA<ServerFailure>()),
      );
    });

    test('adds large coin amounts', () async {
      await useCase.call('user1', 1000000);
      expect(mockRepo.addedCoins, 1000000);
    });
  });
}
