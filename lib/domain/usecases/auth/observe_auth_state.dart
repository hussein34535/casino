import 'package:game_show_app/data/models/user/user_model.dart';
import 'package:game_show_app/domain/repositories/auth_repository.dart';

class ObserveAuthState {
  final AuthRepository authRepository;

  const ObserveAuthState(this.authRepository);

  Stream<UserModel?> call() {
    return authRepository.authStateChanges;
  }
}
