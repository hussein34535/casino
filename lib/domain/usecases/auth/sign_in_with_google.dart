import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/data/models/user/user_model.dart';
import 'package:game_show_app/domain/repositories/auth_repository.dart';

class SignInWithGoogle {
  final AuthRepository authRepository;

  const SignInWithGoogle(this.authRepository);

  Future<UserModel> call() async {
    try {
      return await authRepository.signInWithGoogle();
    } on Failure {
      rethrow;
    } catch (e) {
      throw AuthFailure(message: e.toString());
    }
  }
}
