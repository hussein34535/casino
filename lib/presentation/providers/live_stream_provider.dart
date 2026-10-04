import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/services/streaming/live_stream_service.dart';

final liveStreamServiceProvider = Provider<LiveStreamService>((ref) {
  return LiveStreamService();
});

final liveStreamProvider = StateNotifierProvider<LiveStreamNotifier, LiveStreamState>((ref) {
  return LiveStreamNotifier(ref.read(liveStreamServiceProvider));
});

class LiveStreamState {
  final bool isStreaming;
  final String? streamUrl;
  final String? gameId;
  final String? error;
  final bool isLoading;

  const LiveStreamState({
    this.isStreaming = false,
    this.streamUrl,
    this.gameId,
    this.error,
    this.isLoading = false,
  });

  LiveStreamState copyWith({
    bool? isStreaming,
    String? streamUrl,
    String? gameId,
    String? error,
    bool? isLoading,
  }) {
    return LiveStreamState(
      isStreaming: isStreaming ?? this.isStreaming,
      streamUrl: streamUrl ?? this.streamUrl,
      gameId: gameId ?? this.gameId,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class LiveStreamNotifier extends StateNotifier<LiveStreamState> {
  final LiveStreamService _service;

  LiveStreamNotifier(this._service) : super(const LiveStreamState());

  Future<void> startStream(String gameId, String title) async {
    state = state.copyWith(isLoading: true, error: null, gameId: gameId);
    try {
      final url = await _service.createStream(gameId, title);
      final started = await _service.startStreaming(url);
      state = state.copyWith(
        isStreaming: started,
        streamUrl: url,
        isLoading: false,
        error: started ? null : 'Failed to start stream',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> stopStream() async {
    if (state.streamUrl != null) {
      await _service.endStream(state.streamUrl!);
    }
    state = const LiveStreamState();
  }

  Future<String> generateCommentary(String eventType, String playerName) async {
    return _service.generateCommentary(eventType, playerName);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
