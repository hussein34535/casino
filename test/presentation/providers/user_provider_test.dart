import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/presentation/providers/user_provider.dart';

void main() {
  group('User Providers', () {
    test('userLoadingProvider initial state should be false', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(userLoadingProvider), false);
    });

    test('userLoadingProvider can be updated to true', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(userLoadingProvider.notifier).state = true;
      expect(container.read(userLoadingProvider), true);
    });

    test('userLoadingProvider can be toggled', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(userLoadingProvider.notifier);
      notifier.state = true;
      notifier.state = false;
      expect(container.read(userLoadingProvider), false);
    });
  });
}
