import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/domain/repositories/auth_repository.dart';

class SendPasswordResetEmail {
  final AuthRepository authRepository;

  const SendPasswordResetEmail(this.authRepository);

  Future<void> call(String email) async {
    try {
      return await authRepository.sendPasswordResetEmail(email);
    } on Failure {
      rethrow;
    } catch (e) {
      throw AuthFailure(message: e.toString());
    }
  }
}
