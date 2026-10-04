import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/data/models/user/user_model.dart';
import 'package:game_show_app/domain/repositories/auth_repository.dart';

class SignInWithEmail {
  final AuthRepository authRepository;

  const SignInWithEmail(this.authRepository);

  Future<UserModel> call(String email, String password) async {
    try {
      return await authRepository.signInWithEmail(email, password);
    } on Failure {
      rethrow;
    } catch (e) {
      throw AuthFailure(message: e.toString());
    }
  }
}
