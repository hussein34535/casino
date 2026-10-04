import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/data/models/user/user_model.dart';
import 'package:game_show_app/domain/usecases/auth/sign_out.dart';
import 'package:game_show_app/domain/repositories/auth_repository.dart';

class MockAuthRepo implements AuthRepository {
  bool signOutCalled = false;
  bool shouldThrow = false;

  @override
  Stream<UserModel?> get authStateChanges => Stream.value(null);

  @override
  Future<UserModel?> get currentUser async => null;

  @override
  Future<void> signOut() async {
    signOutCalled = true;
    if (shouldThrow) throw Exception('Sign out failed');
  }

  @override
  Future<UserModel> signInWithEmail(String email, String password) async {
    throw UnimplementedError();
  }

  @override
  Future<UserModel> signUpWithEmail(String email, String password, String displayName) async {
    throw UnimplementedError();
  }

  @override
  Future<UserModel> signInWithGoogle() async => throw UnimplementedError();

  @override
  Future<UserModel> signInWithApple() async => throw UnimplementedError();

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<void> deleteAccount() async {}
}

void main() {
  group('SignOut', () {
    late MockAuthRepo mockRepo;
    late SignOut useCase;

    setUp(() {
      mockRepo = MockAuthRepo();
      useCase = SignOut(mockRepo);
    });

    test('successful sign out calls repository', () async {
      await useCase.call();
      expect(mockRepo.signOutCalled, true);
    });

    test('error during sign out throws AuthFailure', () async {
      mockRepo.shouldThrow = true;
      expect(() => useCase.call(), throwsA(isA<AuthFailure>()));
    });

    test('sign out completes without error', () async {
      await expectLater(useCase.call(), completes);
    });
  });
}
