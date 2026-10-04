import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/domain/repositories/user_repository.dart';

class UpdateSettings {
  final UserRepository userRepository;

  const UpdateSettings(this.userRepository);

  Future<void> call(String uid, Map<String, dynamic> settings) async {
    try {
      return await userRepository.updateProfile(uid, {'settings': settings});
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
