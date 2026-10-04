import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/domain/repositories/user_repository.dart';

class AddCoins {
  final UserRepository userRepository;

  const AddCoins(this.userRepository);

  Future<void> call(String uid, int amount) async {
    try {
      if (amount <= 0) {
        throw ValidationFailure(message: 'Amount must be greater than 0');
      }
      return await userRepository.addCoins(uid, amount);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
