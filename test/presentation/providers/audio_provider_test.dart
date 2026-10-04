import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/presentation/providers/audio_provider.dart';

void main() {
  group('AudioState', () {
    test('initial state has correct defaults', () {
      const state = AudioState();
      expect(state.soundEnabled, true);
      expect(state.musicEnabled, true);
      expect(state.volume, 1.0);
    });

    test('copyWith updates soundEnabled', () {
      const state = AudioState();
      final updated = state.copyWith(soundEnabled: false);
      expect(updated.soundEnabled, false);
      expect(updated.musicEnabled, true);
      expect(updated.volume, 1.0);
    });

    test('copyWith updates musicEnabled', () {
      const state = AudioState();
      final updated = state.copyWith(musicEnabled: false);
      expect(updated.soundEnabled, true);
      expect(updated.musicEnabled, false);
      expect(updated.volume, 1.0);
    });

    test('copyWith updates volume', () {
      const state = AudioState();
      final updated = state.copyWith(volume: 0.5);
      expect(updated.soundEnabled, true);
      expect(updated.musicEnabled, true);
      expect(updated.volume, 0.5);
    });

    test('copyWith returns same instance when no args', () {
      const state = AudioState();
      final updated = state.copyWith();
      expect(updated.soundEnabled, true);
      expect(updated.musicEnabled, true);
      expect(updated.volume, 1.0);
    });
  });

  group('AudioNotifier', () {
    test('initial state via provider', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final state = container.read(audioProvider);
      expect(state.soundEnabled, true);
      expect(state.musicEnabled, true);
      expect(state.volume, 1.0);
    });

    test('toggleSound flips soundEnabled', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(audioProvider.notifier);
      notifier.toggleSound();
      expect(container.read(audioProvider).soundEnabled, false);
      notifier.toggleSound();
      expect(container.read(audioProvider).soundEnabled, true);
    });

    test('toggleMusic flips musicEnabled', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(audioProvider.notifier);
      notifier.toggleMusic();
      expect(container.read(audioProvider).musicEnabled, false);
      notifier.toggleMusic();
      expect(container.read(audioProvider).musicEnabled, true);
    });

    test('setVolume clamps to 0.0 minimum', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(audioProvider.notifier);
      notifier.setVolume(-0.5);
      expect(container.read(audioProvider).volume, 0.0);
    });

    test('setVolume clamps to 1.0 maximum', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(audioProvider.notifier);
      notifier.setVolume(1.5);
      expect(container.read(audioProvider).volume, 1.0);
    });

    test('setVolume accepts valid values', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(audioProvider.notifier);
      notifier.setVolume(0.5);
      expect(container.read(audioProvider).volume, 0.5);
      notifier.setVolume(0.0);
      expect(container.read(audioProvider).volume, 0.0);
      notifier.setVolume(1.0);
      expect(container.read(audioProvider).volume, 1.0);
    });

    test('toggleSound does not affect music or volume', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(audioProvider.notifier);
      notifier.toggleSound();
      final state = container.read(audioProvider);
      expect(state.soundEnabled, false);
      expect(state.musicEnabled, true);
      expect(state.volume, 1.0);
    });

    test('toggleMusic does not affect sound or volume', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(audioProvider.notifier);
      notifier.toggleMusic();
      final state = container.read(audioProvider);
      expect(state.soundEnabled, true);
      expect(state.musicEnabled, false);
      expect(state.volume, 1.0);
    });
  });
}
