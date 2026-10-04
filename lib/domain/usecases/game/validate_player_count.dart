import 'package:game_show_app/core/errors/failures.dart';

class ValidatePlayerCount {
  void call(int count) {
    if (count < 2) {
      throw const ValidationFailure(message: 'Minimum 2 players required');
    }
    if (count > 10) {
      throw const ValidationFailure(message: 'Maximum 10 players allowed');
    }
  }
}
