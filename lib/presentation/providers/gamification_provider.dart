import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_show_app/data/models/gamification/battle_pass_model.dart';
import 'package:game_show_app/data/models/gamification/daily_challenge_model.dart';
import 'package:game_show_app/data/models/gamification/shop_item_model.dart';
import 'package:game_show_app/data/models/gamification/user_progress_model.dart';
import 'package:game_show_app/presentation/providers/auth_provider.dart';
import 'package:game_show_app/presentation/providers/user_provider.dart';
import 'package:game_show_app/services/gamification/battle_pass_service.dart';
import 'package:game_show_app/services/gamification/challenge_service.dart';
import 'package:game_show_app/services/gamification/leveling_service.dart';
import 'package:game_show_app/services/gamification/reward_service.dart';
import 'package:game_show_app/services/gamification/shop_service.dart';
import 'package:game_show_app/services/gamification/streak_service.dart';

final battlePassServiceProvider = Provider<BattlePassService>((ref) {
  return BattlePassService(FirebaseFirestore.instance);
});

final challengeServiceProvider = Provider<ChallengeService>((ref) {
  return ChallengeService(FirebaseFirestore.instance);
});

final rewardServiceProvider = Provider<RewardService>((ref) {
  return RewardService(ref.read(userRepositoryProvider));
});

final shopServiceProvider = Provider<ShopService>((ref) {
  return ShopService(FirebaseFirestore.instance);
});

final streakServiceProvider = Provider<StreakService>((ref) {
  return StreakService(FirebaseFirestore.instance);
});

final levelingServiceProvider = Provider<LevelingService>((ref) {
  return LevelingService();
});

final battlePassProvider = FutureProvider<BattlePassModel?>((ref) async {
  final userId = ref.watch(authStateProvider).valueOrNull?.id;
  if (userId == null) return null;
  return ref.read(battlePassServiceProvider).getBattlePass(userId);
});

final dailyChallengesProvider = FutureProvider<List<DailyChallengeModel>>((ref) async {
  return ref.read(challengeServiceProvider).getDailyChallenges();
});

final weeklyChallengesProvider = FutureProvider<List<DailyChallengeModel>>((ref) async {
  return ref.read(challengeServiceProvider).getWeeklyChallenges();
});

final monthlyChallengesProvider = FutureProvider<List<DailyChallengeModel>>((ref) async {
  return ref.read(challengeServiceProvider).getMonthlyChallenges();
});

final shopItemsProvider = FutureProvider<List<ShopItemModel>>((ref) async {
  return ref.read(shopServiceProvider).getShopItems();
});

final featuredItemsProvider = FutureProvider<List<ShopItemModel>>((ref) async {
  return ref.read(shopServiceProvider).getFeaturedItems();
});

final discountedItemsProvider = FutureProvider<List<ShopItemModel>>((ref) async {
  return ref.read(shopServiceProvider).getDiscountedItems();
});

final userProgressProvider = FutureProvider<UserProgressModel?>((ref) async {
  final userId = ref.watch(authStateProvider).valueOrNull?.id;
  if (userId == null) return null;
  return UserProgressModel(userId: userId);
});
