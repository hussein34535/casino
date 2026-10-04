import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/data/models/user/user_model.dart';
import 'package:game_show_app/domain/repositories/social_repository.dart';
import 'package:game_show_app/presentation/providers/auth_provider.dart';
import 'package:game_show_app/presentation/providers/social_provider.dart';

class MockSocialRepository implements SocialRepository {
  List<UserModel> friends = [];
  bool shouldThrow = false;

  @override
  Stream<List<UserModel>> getFriends(String userId) {
    if (shouldThrow) return Stream.error(Exception('Mock error'));
    return Stream.value(friends);
  }

  @override
  Future<void> sendFriendRequest(String fromId, String toId) async {}

  @override
  Future<void> acceptFriendRequest(String docId) async {}

  @override
  Future<void> rejectFriendRequest(String docId) async {}

  @override
  Future<void> blockUser(String userId, String blockedId) async {}

  @override
  Future<List<UserModel>> searchUsers(String query) async => [];
}

void main() {
  group('SocialProvider', () {
    late MockSocialRepository mockSocialRepo;
    late UserModel mockUser;

    setUp(() {
      mockSocialRepo = MockSocialRepository();
      mockUser = UserModel(id: 'user1', email: 'test@test.com', displayName: 'Test User');
    });

    test('friendsProvider returns friend list when user is authenticated', () async {
      mockSocialRepo.friends = [
        UserModel(id: 'f1', email: 'f1@test.com', displayName: 'Friend One'),
        UserModel(id: 'f2', email: 'f2@test.com', displayName: 'Friend Two'),
      ];

      final container = ProviderContainer(
        overrides: [
          socialRepositoryProvider.overrideWithValue(mockSocialRepo),
          authStateProvider.overrideWith((ref) => Stream.value(mockUser)),
        ],
      );
      addTearDown(container.dispose);

      // Trigger auth stream to emit so friendsProvider sees cached value
      container.read(authStateProvider);
      await Future(() {});

      final result = await container.read(friendsProvider.future);
      expect(result.length, 2);
      expect(result[0].displayName, 'Friend One');
      expect(result[1].displayName, 'Friend Two');
    });

    test('friendsProvider returns empty stream when user is not authenticated', () async {
      mockSocialRepo.friends = [
        UserModel(id: 'f1', email: 'f1@test.com', displayName: 'Friend One'),
      ];

      final container = ProviderContainer(
        overrides: [
          socialRepositoryProvider.overrideWithValue(mockSocialRepo),
          authStateProvider.overrideWith((ref) => const Stream.empty()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(friendsProvider).valueOrNull, isNull);
    });

    test('friendsProvider handles stream errors from repository', () async {
      mockSocialRepo.shouldThrow = true;

      final container = ProviderContainer(
        overrides: [
          socialRepositoryProvider.overrideWithValue(mockSocialRepo),
          authStateProvider.overrideWith((ref) => Stream.value(mockUser)),
        ],
      );
      addTearDown(container.dispose);

      container.read(authStateProvider);
      await Future(() {});

      await expectLater(
        container.read(friendsProvider.future),
        throwsA(isA<Exception>()),
      );
    });
  });
}
