import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';
import 'package:game_show_app/data/models/achievement/achievement_model.dart';
import 'package:game_show_app/presentation/widgets/common/xo_loading.dart';

final achievementsProvider = FutureProvider<List<AchievementModel>>((ref) async {
  // TODO: Replace with actual repository call
  return [
    AchievementModel(id: '1', name: 'أول فوز', description: 'اربح أول مباراة لك', iconName: 'trophy', xpReward: 50),
    AchievementModel(id: '2', name: 'المحارب', description: 'العب 10 مباريات', iconName: 'sword', requiredProgress: 10, xpReward: 100),
    AchievementModel(id: '3', name: 'النقاط العشر', description: 'احصل على 10 نقاط في مباراة واحدة', iconName: 'star', xpReward: 75),
    AchievementModel(id: '4', name: 'الخبير', description: 'أجب على 50 سؤالاً', iconName: 'brain', requiredProgress: 50, xpReward: 200),
    AchievementModel(id: '5', name: 'المثابر', description: 'العب 7 أيام متتالية', iconName: 'fire', requiredProgress: 7, xpReward: 150),
    AchievementModel(id: '6', name: 'الصداقة', description: 'أضف 5 أصدقاء', iconName: 'heart', requiredProgress: 5, xpReward: 50),
  ];
});

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievementsAsync = ref.watch(achievementsProvider);

    return Scaffold(
      backgroundColor: ComicColors.cream,
      appBar: AppBar(
        backgroundColor: ComicColors.blue,
        title: const Text('الإنجازات', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)),
        shape: const Border(bottom: BorderSide(color: ComicColors.black, width: 3)),
      ),
      body: achievementsAsync.when(
        loading: () => const XoShimmerLoading(itemCount: 6),
        error: (e, _) => XoErrorWidget(
          message: 'خطأ في تحميل الإنجازات',
          onRetry: () => ref.invalidate(achievementsProvider),
        ),
        data: (achievements) {
          if (achievements.isEmpty) {
            return const XoEmptyState(
              title: 'لا توجد إنجازات بعد',
              subtitle: 'حاول إكمال المزيد من المباريات',
              icon: Icons.emoji_events,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final achievement = achievements[index];
              return ComicCard(
                padding: EdgeInsets.zero,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: ComicColors.yellow,
                    child: const Icon(Icons.emoji_events, color: ComicColors.black),
                  ),
                  title: Text(achievement.name, style: const TextStyle(fontWeight: FontWeight.w900)),
                  subtitle: Text(achievement.description),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${achievement.xpReward}', style: const TextStyle(
                        color: ComicColors.black,
                        fontWeight: FontWeight.w900,
                      )),
                      const Text('XP', style: TextStyle(fontSize: 10, color: ComicColors.grey)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
