import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/domain/repositories/user_repository.dart';

class ManageUsers {
  final UserRepository userRepository;

  ManageUsers(this.userRepository);

  Future<void> banUser(String uid) async {
    try {
      await userRepository.updateProfile(uid, {'banned': true});
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  Future<void> unbanUser(String uid) async {
    try {
      await userRepository.updateProfile(uid, {'banned': false});
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      await userRepository.updateProfile(uid, {'deleted': true});
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  Future<void> promoteToAdmin(String uid) async {
    try {
      await userRepository.updateProfile(uid, {'role': 'admin'});
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
