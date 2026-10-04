import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/data/models/user/user_model.dart';
import 'package:game_show_app/domain/usecases/auth/sign_in_with_email.dart';
import 'package:game_show_app/domain/repositories/auth_repository.dart';

class MockAuthRepo implements AuthRepository {
  bool shouldThrow = false;
  bool throwAuthFailure = false;

  @override
  Stream<UserModel?> get authStateChanges => Stream.value(null);

  @override
  Future<UserModel?> get currentUser async => null;

  @override
  Future<UserModel> signInWithEmail(String email, String password) async {
    if (shouldThrow) {
      if (throwAuthFailure) {
        throw const AuthFailure(message: 'Invalid credentials');
      }
      throw Exception('Network error');
    }
    return UserModel(id: '1', email: email, displayName: 'Test');
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
  Future<void> signOut() async {}

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<void> deleteAccount() async {}
}

void main() {
  group('SignInWithEmail', () {
    late MockAuthRepo mockRepo;
    late SignInWithEmail useCase;

    setUp(() {
      mockRepo = MockAuthRepo();
      useCase = SignInWithEmail(mockRepo);
    });

    test('successful sign in returns UserModel', () async {
      final user = await useCase.call('test@example.com', 'password123');
      expect(user, isA<UserModel>());
      expect(user.email, 'test@example.com');
    });

    test('error handling wraps generic exception in AuthFailure', () async {
      mockRepo.shouldThrow = true;
      mockRepo.throwAuthFailure = false;
      expect(
        () => useCase.call('test@example.com', 'password123'),
        throwsA(isA<AuthFailure>()),
      );
    });

    test('invalid credentials throw AuthFailure', () async {
      mockRepo.shouldThrow = true;
      mockRepo.throwAuthFailure = true;
      expect(
        () => useCase.call('wrong@email.com', 'wrongpass'),
        throwsA(isA<AuthFailure>()),
      );
    });

    test('AuthFailure from repository is rethrown', () async {
      mockRepo.shouldThrow = true;
      mockRepo.throwAuthFailure = true;
      try {
        await useCase.call('test@example.com', 'password123');
        fail('Expected AuthFailure');
      } on AuthFailure catch (e) {
        expect(e.message, 'Invalid credentials');
      }
    });
  });
}
