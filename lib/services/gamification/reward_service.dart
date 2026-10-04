import 'package:game_show_app/domain/repositories/user_repository.dart';

class RewardService {
  final UserRepository _userRepository;

  RewardService(this._userRepository);

  Future<void> grantXp(String userId, int amount) async {
    await _userRepository.addXp(userId, amount);
  }

  Future<void> grantCoins(String userId, int amount) async {
    await _userRepository.addCoins(userId, amount);
  }

  Future<void> grantItem(String userId, String itemId) async {
    await _userRepository.addItemToInventory(userId, itemId);
  }

  Future<List<String>> getInventory(String userId) async {
    return await _userRepository.getInventory(userId);
  }

  Future<bool> equipItem(String userId, String itemId) async {
    return await _userRepository.equipItem(userId, itemId);
  }
}