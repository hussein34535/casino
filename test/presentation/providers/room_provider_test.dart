import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:game_show_app/presentation/providers/room_provider.dart';
import 'package:game_show_app/presentation/providers/auth_provider.dart';
import 'package:game_show_app/data/models/game/game_session_model.dart';
import 'package:game_show_app/data/models/user/user_model.dart';

class MockRef extends Mock implements Ref {}

void main() {
  late ProviderContainer container;
  late UserModel testUser;

  setUp(() {
    testUser = UserModel(
      id: 'user123',
      email: 'test@example.com',
      displayName: 'Test User',
    );

    container = ProviderContainer(
      overrides: [
        // Mock the auth state to return our test user
        authStateProvider.overrideWith((ref) => Stream.value(testUser)),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('RoomNotifier Tests', () {
    test('Initial state is null data', () {
      final state = container.read(roomNotifierProvider);
      expect(state, const AsyncValue.data(null));
    });

    test('currentRoomIdProvider is initially null', () {
      final roomId = container.read(currentRoomIdProvider);
      expect(roomId, isNull);
    });

    // Note: In a real app, we would mock FirestoreService to test createRoom/joinRoom
    // but here we focus on the provider structure being correct.
  });

  group('Room Session Stream Provider', () {
    test('Returns empty stream when no roomId is set', () {
      final session = container.read(roomSessionStreamProvider);
      expect(session, const AsyncValue<GameSessionModel?>.loading());
    });
  });
}
