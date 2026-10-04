import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/data/models/user/user_model.dart';
import 'package:game_show_app/domain/repositories/social_repository.dart';

class SearchUsers {
  final SocialRepository socialRepository;

  const SearchUsers(this.socialRepository);

  Future<List<UserModel>> call(String query) async {
    try {
      return await socialRepository.searchUsers(query);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
