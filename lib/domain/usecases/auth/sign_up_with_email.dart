import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/data/models/user/user_model.dart';
import 'package:game_show_app/domain/repositories/auth_repository.dart';

class SignUpWithEmail {
  final AuthRepository authRepository;

  const SignUpWithEmail(this.authRepository);

  Future<UserModel> call(String email, String password, String displayName) async {
    try {
      return await authRepository.signUpWithEmail(email, password, displayName);
    } on Failure {
      rethrow;
    } catch (e) {
      throw AuthFailure(message: e.toString());
    }
  }
}
