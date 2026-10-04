import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/data/models/user/user_model.dart';
import 'package:game_show_app/domain/usecases/auth/sign_up_with_email.dart';
import 'package:game_show_app/domain/repositories/auth_repository.dart';

class MockAuthRepo implements AuthRepository {
  bool shouldThrow = false;

  @override
  Stream<UserModel?> get authStateChanges => Stream.value(null);

  @override
  Future<UserModel?> get currentUser async => null;

  @override
  Future<UserModel> signInWithEmail(String email, String password) async {
    throw UnimplementedError();
  }

  @override
  Future<UserModel> signUpWithEmail(String email, String password, String displayName) async {
    if (shouldThrow) throw Exception('Mock error');
    return UserModel(id: 'new', email: email, displayName: displayName);
  }

  @override
  Future<UserModel> signInWithGoogle() async => throw UnimplementedError();

  @override
  Future<UserModel> signInWithApple() async => throw UnimplementedError();

  @override
  Future<void> signOut() async {}

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<void> deleteAccount() async {}
}

void main() {
  group('SignUpWithEmail', () {
    late MockAuthRepo mockRepo;
    late SignUpWithEmail useCase;

    setUp(() {
      mockRepo = MockAuthRepo();
      useCase = SignUpWithEmail(mockRepo);
    });

    test('successful sign up returns UserModel', () async {
      final user = await useCase.call('new@example.com', 'password123', 'New User');
      expect(user.id, 'new');
      expect(user.email, 'new@example.com');
      expect(user.displayName, 'New User');
    });

    test('duplicate email throws AuthFailure', () async {
      mockRepo.shouldThrow = true;
      expect(
        () => useCase.call('existing@example.com', 'password123', 'User'),
        throwsA(isA<AuthFailure>()),
      );
    });

    test('weak password throws AuthFailure', () async {
      mockRepo.shouldThrow = true;
      expect(
        () => useCase.call('test@example.com', '123', 'User'),
        throwsA(isA<AuthFailure>()),
      );
    });

    test('AuthFailure is rethrown directly', () async {
      mockRepo.shouldThrow = true;
      try {
        await useCase.call('test@example.com', 'password', 'Test');
        fail('Expected AuthFailure');
      } on AuthFailure {
        // Expected
      } catch (e) {
        fail('Expected AuthFailure but got $e');
      }
    });
  });
}
