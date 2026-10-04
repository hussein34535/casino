import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/data/models/user/user_model.dart';
import 'package:game_show_app/domain/repositories/auth_repository.dart';

class GetCurrentUser {
  final AuthRepository authRepository;

  const GetCurrentUser(this.authRepository);

  Future<UserModel> call() async {
    final user = await authRepository.currentUser;
    if (user == null) {
      throw const NotFoundFailure(message: 'No current user found');
    }
    return user;
  }
}
