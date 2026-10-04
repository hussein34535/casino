import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudioState {
  final bool soundEnabled;
  final bool musicEnabled;
  final double volume;

  const AudioState({
    this.soundEnabled = true,
    this.musicEnabled = true,
    this.volume = 1.0,
  });

  AudioState copyWith({bool? soundEnabled, bool? musicEnabled, double? volume}) {
    return AudioState(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      volume: volume ?? this.volume,
    );
  }
}

class AudioNotifier extends StateNotifier<AudioState> {
  AudioNotifier() : super(const AudioState());

  void toggleSound() => state = state.copyWith(soundEnabled: !state.soundEnabled);
  void toggleMusic() => state = state.copyWith(musicEnabled: !state.musicEnabled);
  void setVolume(double v) => state = state.copyWith(volume: v.clamp(0.0, 1.0));
}

final audioProvider = StateNotifierProvider<AudioNotifier, AudioState>((ref) => AudioNotifier());
