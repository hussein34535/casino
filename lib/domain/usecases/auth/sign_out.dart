import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/domain/repositories/auth_repository.dart';

class SignOut {
  final AuthRepository authRepository;

  const SignOut(this.authRepository);

  Future<void> call() async {
    try {
      return await authRepository.signOut();
    } on Failure {
      rethrow;
    } catch (e) {
      throw AuthFailure(message: e.toString());
    }
  }
}
