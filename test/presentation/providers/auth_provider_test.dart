import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/presentation/providers/auth_provider.dart';

void main() {
  group('Auth Providers', () {
    test('authLoadingProvider initial state should be false', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(authLoadingProvider), false);
    });

    test('authErrorProvider initial state should be null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(authErrorProvider), null);
    });

    test('authLoadingProvider can be updated', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(authLoadingProvider.notifier).state = true;
      expect(container.read(authLoadingProvider), true);
    });

    test('authErrorProvider can be updated', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(authErrorProvider.notifier).state = 'Error occurred';
      expect(container.read(authErrorProvider), 'Error occurred');
    });

    test('authErrorProvider can be reset to null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(authErrorProvider.notifier).state = 'Error';
      container.read(authErrorProvider.notifier).state = null;
      expect(container.read(authErrorProvider), null);
    });
  });
}
