import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/domain/repositories/user_repository.dart';

class UploadAvatar {
  final UserRepository userRepository;

  const UploadAvatar(this.userRepository);

  Future<void> call(String uid, String filePath) async {
    try {
      return await userRepository.uploadAvatar(uid, filePath);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
