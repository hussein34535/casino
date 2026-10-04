import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/domain/repositories/user_repository.dart';

class UpdateUserProfile {
  final UserRepository userRepository;

  const UpdateUserProfile(this.userRepository);

  Future<void> call(String uid, Map<String, dynamic> data) async {
    try {
      if (data.isEmpty) {
        throw ValidationFailure(message: 'Data cannot be empty');
      }
      return await userRepository.updateProfile(uid, data);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
