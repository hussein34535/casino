import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:game_show_app/presentation/providers/seed_provider.dart';
import 'package:game_show_app/services/firebase/seed_service.dart';

class MockSeedService implements SeedService {
  bool shouldThrow = false;

  @override
  Future<SeedResult> seedAllQuestions() async {
    if (shouldThrow) throw Exception('Mock error');
    return SeedResult(totalQuestions: 42, errors: []);
  }
}

void main() {
  group('Seed Providers', () {
    group('firestoreProvider', () {
      test('requires Firebase initialization', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        // NOTE: firestoreProvider returns FirebaseFirestore.instance directly
        // (not overridable via a provider). This requires Firebase to be
        // initialized first via Firebase.initializeApp().
        // Without it, reading the provider throws a FirebaseException.
        expect(
          () => container.read(firestoreProvider),
          throwsA(isA<FirebaseException>()),
        );
      });
    });

    group('seedServiceProvider', () {
      test('can be overridden with a mock service', () {
        final mockService = MockSeedService();
        final container = ProviderContainer(
          overrides: [
            seedServiceProvider.overrideWithValue(mockService),
          ],
        );
        addTearDown(container.dispose);

        final service = container.read(seedServiceProvider);
        expect(service, same(mockService));
      });

      test('mock returns the correct type', () {
        final mockService = MockSeedService();
        final container = ProviderContainer(
          overrides: [
            seedServiceProvider.overrideWithValue(mockService),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(seedServiceProvider), isA<SeedService>());
      });
    });

    group('seedQuestionsProvider', () {
      test('returns SeedResult from overridden mock service', () async {
        final mockService = MockSeedService();
        final container = ProviderContainer(
          overrides: [
            seedServiceProvider.overrideWithValue(mockService),
          ],
        );
        addTearDown(container.dispose);

        final result = await container.read(seedQuestionsProvider.future);
        expect(result, isA<SeedResult>());
        expect(result.totalQuestions, 42);
        expect(result.hasErrors, isFalse);
        expect(result.errors, isEmpty);
      });

      test('handles errors thrown by the service', () async {
        final mockService = MockSeedService();
        mockService.shouldThrow = true;
        final container = ProviderContainer(
          overrides: [
            seedServiceProvider.overrideWithValue(mockService),
          ],
        );
        addTearDown(container.dispose);

        await expectLater(
          container.read(seedQuestionsProvider.future),
          throwsA(isA<Exception>()),
        );
      });

      test('multiple reads return fresh results without caching', () async {
        final mockService = MockSeedService();
        final container = ProviderContainer(
          overrides: [
            seedServiceProvider.overrideWithValue(mockService),
          ],
        );
        addTearDown(container.dispose);

        final result1 = await container.read(seedQuestionsProvider.future);
        final result2 = await container.read(seedQuestionsProvider.future);
        expect(result1.totalQuestions, 42);
        expect(result2.totalQuestions, 42);
      });
    });
  });
}
