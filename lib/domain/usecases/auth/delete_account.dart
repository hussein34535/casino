import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/domain/repositories/auth_repository.dart';

class DeleteAccount {
  final AuthRepository authRepository;

  const DeleteAccount(this.authRepository);

  Future<void> call() async {
    try {
      return await authRepository.deleteAccount();
    } on Failure {
      rethrow;
    } catch (e) {
      throw AuthFailure(message: e.toString());
    }
  }
}
