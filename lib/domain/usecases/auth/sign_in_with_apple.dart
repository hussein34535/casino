import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/data/models/user/user_model.dart';
import 'package:game_show_app/domain/repositories/auth_repository.dart';

class SignInWithApple {
  final AuthRepository authRepository;

  const SignInWithApple(this.authRepository);

  Future<UserModel> call() async {
    try {
      return await authRepository.signInWithApple();
    } on Failure {
      rethrow;
    } catch (e) {
      throw AuthFailure(message: e.toString());
    }
  }
}
