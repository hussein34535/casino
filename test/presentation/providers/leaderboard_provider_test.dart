import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/data/models/leaderboard/leaderboard_model.dart';
import 'package:game_show_app/presentation/providers/leaderboard_provider.dart';
import 'package:game_show_app/presentation/providers/user_provider.dart';
import '../../helpers/mock_repositories.dart';

void main() {
  group('LeaderboardProvider', () {
    late MockUserRepository mockUserRepo;

    setUp(() {
      mockUserRepo = MockUserRepository();
    });

    test('leaderboardProvider returns leaderboard data for weekly period', () async {
      mockUserRepo.leaderboard = [
        LeaderboardEntry(userId: '1', displayName: 'Alice', score: 100, rank: 1),
        LeaderboardEntry(userId: '2', displayName: 'Bob', score: 80, rank: 2),
      ];

      final container = ProviderContainer(
        overrides: [
          userRepositoryProvider.overrideWithValue(mockUserRepo),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(leaderboardProvider('weekly').future);
      expect(result.length, 2);
      expect(result[0].displayName, 'Alice');
      expect(result[0].score, 100);
      expect(result[1].displayName, 'Bob');
      expect(result[1].score, 80);
    });

    test('leaderboardProvider handles errors gracefully', () async {
      mockUserRepo.shouldThrow = true;

      final container = ProviderContainer(
        overrides: [
          userRepositoryProvider.overrideWithValue(mockUserRepo),
        ],
      );
      addTearDown(container.dispose);

      await expectLater(
        container.read(leaderboardProvider('weekly').future),
        throwsA(isA<Exception>()),
      );
    });
  });
}
