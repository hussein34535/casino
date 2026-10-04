import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/data/models/game/game_session_model.dart';
import 'package:game_show_app/data/models/game/player_model.dart';
import 'package:game_show_app/presentation/providers/auth_provider.dart';


final currentRoomIdProvider = StateProvider<String?>((ref) => null);

/// Live list of public rooms waiting for players.
final openRoomsProvider = StreamProvider<List<GameSessionModel>>((ref) {
  final firestore = ref.watch(firestoreServiceProvider);
  return firestore.openRoomsStream().map((snap) => snap.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return GameSessionModel.fromJson(data);
      }).toList());
});

final roomSessionStreamProvider = StreamProvider<GameSessionModel?>((ref) {
  final roomId = ref.watch(currentRoomIdProvider);
  if (roomId == null) return Stream.value(null);

  final firestore = ref.watch(firestoreServiceProvider);
  // Ignore initial events where the document doesn't exist yet to prevent UI hangs
  return firestore.gameSessionStream(roomId).where((doc) => doc.exists).map((doc) {
    final data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return GameSessionModel.fromJson(data);
  });
});

class RoomNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  RoomNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> createRoom({
    required List<String> categories,
    int maxPlayers = 5,
    bool isPublic = true,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = _ref.read(authStateProvider).value;
      if (user == null) throw Exception('يجب تسجيل الدخول لإنشاء غرفة');

      final firestore = _ref.read(firestoreServiceProvider);

      // Generate a random 6 digit code
      final roomCode = (100000 + Random().nextInt(900000)).toString();

      String playerName = user.displayName;
      if (playerName.trim().isEmpty) {
        playerName = user.email.split('@').first;
      }

      final hostPlayer = PlayerModel(
        id: user.id,
        name: playerName,
        photoUrl: user.photoUrl,
        score: 0,
        isHost: true,
      );

      final session = GameSessionModel(
        id: '',
        hostId: user.id,
        roomCode: roomCode,
        categories: categories,
        status: 'waiting',
        maxPlayers: maxPlayers.clamp(2, 5),
        players: [hostPlayer],
        playerIds: [user.id],
        isPublic: isPublic,
      );

      final roomId = await firestore.createGameSession(session.toJson());
      _ref.read(currentRoomIdProvider.notifier).state = roomId;
      
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> joinRoom(String roomCode) async {
    state = const AsyncValue.loading();
    try {
      final user = _ref.read(authStateProvider).value;
      if (user == null) throw Exception('يجب تسجيل الدخول للانضمام لغرفة');

      final firestore = _ref.read(firestoreServiceProvider);
      
      final query = await firestore.getGameSessionByCode(roomCode);
      if (query.docs.isEmpty) {
        throw Exception('الغرفة غير موجودة أو بدأت اللعب بالفعل');
      }

      final doc = query.docs.first;
      final sessionData = doc.data() as Map<String, dynamic>;
      final session = GameSessionModel.fromJson(sessionData);

      // Check if room is full
      if (session.players.length >= session.maxPlayers) {
        throw Exception('عذراً، الغرفة ممتلئة بالكامل');
      }

      // Check if already in room
      final alreadyInRoom = session.players.any((p) => p.id == user.id);
      
      if (!alreadyInRoom) {
        String playerName = user.displayName;
        if (playerName.trim().isEmpty) {
          playerName = user.email.split('@').first;
        }

        final newPlayer = PlayerModel(
          id: user.id,
          name: playerName,
          photoUrl: user.photoUrl,
          score: 0,
          isHost: false,
        );
        
        session.players.add(newPlayer);
        session.playerIds.add(user.id);
        await firestore.updateGameSession(doc.id, {
          'players': session.players.map((p) => p.toJson()).toList(),
          'playerIds': session.playerIds,
        });
      }

      _ref.read(currentRoomIdProvider.notifier).state = doc.id;
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> startGame() async {
    final roomId = _ref.read(currentRoomIdProvider);
    if (roomId == null) return;

    final firestore = _ref.read(firestoreServiceProvider);
    await firestore.updateGameSession(roomId, {
      'status': 'playing',
      'startedAt': DateTime.now().toIso8601String(),
    });
  }
  
  Future<void> leaveRoom() async {
    final roomId = _ref.read(currentRoomIdProvider);
    final user = _ref.read(authStateProvider).value;
    
    if (roomId != null && user != null) {
      // Best effort removal
      try {
        final firestore = _ref.read(firestoreServiceProvider);
        final doc = await firestore.getGameSession(roomId);
        if (doc.exists) {
          final session = GameSessionModel.fromJson(doc.data() as Map<String, dynamic>);
          session.players.removeWhere((p) => p.id == user.id);
          session.playerIds.remove(user.id);

          if (session.players.isEmpty) {
            // Delete room if empty (Optional, might need a Cloud Function for clean up instead)
            await firestore.updateGameSession(roomId, {'status': 'cancelled'});
          } else {
            await firestore.updateGameSession(roomId, {
              'players': session.players.map((p) => p.toJson()).toList(),
              'playerIds': session.playerIds,
            });
          }
        }
      } catch (_) {}
    }
    
    _ref.read(currentRoomIdProvider.notifier).state = null;
  }
}

final roomNotifierProvider = StateNotifierProvider<RoomNotifier, AsyncValue<void>>((ref) {
  return RoomNotifier(ref);
});
