import 'package:game_show_app/data/models/gamification/level_reward_model.dart';

class LevelingService {
  int calculateLevel(int xp) {
    return (xp / 100).floor() + 1;
  }

  int getTotalXpForLevel(int level) {
    return (level - 1) * 100;
  }

  int getXpForNextLevel(int currentXp) {
    final currentLevel = calculateLevel(currentXp);
    return currentLevel * 100 - currentXp;
  }

  List<LevelRewardModel> getLevelRewards(int level) {
    const rewards = {
      5: LevelRewardModel(level: 5, description: 'شخصية جديدة', type: LevelRewardType.item, itemId: 'avatar_lvl5'),
      10: LevelRewardModel(level: 10, description: '500 عملة', type: LevelRewardType.coins, amount: 500),
      15: LevelRewardModel(level: 15, description: 'لقب خبير', type: LevelRewardType.title, itemId: 'title_expert'),
      20: LevelRewardModel(level: 20, description: '1000 عملة', type: LevelRewardType.coins, amount: 1000),
      25: LevelRewardModel(level: 25, description: 'ثيم حصري', type: LevelRewardType.item, itemId: 'theme_lvl25'),
      30: LevelRewardModel(level: 30, description: 'لقب أسطورة', type: LevelRewardType.title, itemId: 'title_legend'),
      40: LevelRewardModel(level: 40, description: '2000 عملة + شخصية نادرة', type: LevelRewardType.badge, amount: 2000, itemId: 'avatar_rare_lvl40'),
      50: LevelRewardModel(level: 50, description: 'وسام البطل الأسطوري', type: LevelRewardType.badge, itemId: 'badge_legend'),
    };
    return rewards.values.where((r) => r.level == level).toList();
  }
}
