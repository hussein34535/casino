import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';
import 'package:game_show_app/presentation/providers/gamification_provider.dart';
import 'package:game_show_app/presentation/widgets/common/xo_card.dart';
import 'package:game_show_app/presentation/widgets/common/xo_loading.dart';

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(userProgressProvider);
    final levelingService = ref.read(levelingServiceProvider);

    return Scaffold(
      backgroundColor: ComicColors.cream,
      appBar: AppBar(
        backgroundColor: ComicColors.blue,
        title: const Text('المكافآت', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)),
        shape: const Border(bottom: BorderSide(color: ComicColors.black, width: 3)),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: progressAsync.when(
          loading: () => const XoLoading(),
          error: (e, _) => XoErrorWidget(message: 'خطأ: $e'),
          data: (progress) {
            if (progress == null) {
              return const XoEmptyState(title: 'يرجى تسجيل الدخول');
            }

            final int currentLevel = progress.level;
            final int currentXp = progress.xp;
            final int xpForNext = levelingService.getXpForNextLevel(currentXp);
            final int totalForLevel = levelingService.getTotalXpForLevel(currentLevel);
            final double levelProgress = xpForNext > 0
                ? (currentXp - totalForLevel) / (totalForLevel + xpForNext - totalForLevel)
                : 0.0;

            final levelRewards = [
              levelingService.getLevelRewards(5),
              levelingService.getLevelRewards(10),
              levelingService.getLevelRewards(15),
              levelingService.getLevelRewards(20),
              levelingService.getLevelRewards(25),
              levelingService.getLevelRewards(30),
              levelingService.getLevelRewards(40),
              levelingService.getLevelRewards(50),
            ].expand((list) => list).toList();

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                XoCard(
                  padding: const EdgeInsets.all(20),
                  backgroundColor: ComicColors.white,
                  gradientColors: [
                    ComicColors.yellow.withValues(alpha: 0.25),
                    ComicColors.orange.withValues(alpha: 0.12),
                  ],
                  borderColor: ComicColors.black,
                  child: Column(
                    children: [
                      const Icon(Icons.star, size: 48, color: ComicColors.orange),
                      const SizedBox(height: 8),
                      Text(
                        'المستوى $currentLevel',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: ComicColors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star, size: 14, color: ComicColors.grey),
                          const SizedBox(width: 4),
                          Text('$currentXp XP', style: const TextStyle(color: ComicColors.grey)),
                          const SizedBox(width: 8),
                          const Text('→', style: TextStyle(color: ComicColors.grey)),
                          const SizedBox(width: 8),
                          Text('${currentLevel * 100} XP', style: const TextStyle(color: ComicColors.grey)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: ComicColors.black, width: 2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: levelProgress.clamp(0.0, 1.0),
                            backgroundColor: ComicColors.cream,
                            color: ComicColors.yellow,
                            minHeight: 10,
                          ),
                        ),
                      ),
                      if (xpForNext > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'يتبقى $xpForNext XP للمستوى التالي',
                            style: const TextStyle(fontSize: 12, color: ComicColors.grey),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'مكافآت المستويات',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: ComicColors.black),
                ),
                const SizedBox(height: 8),
                ...levelRewards.map((reward) {
                  final bool isUnlocked = currentLevel >= reward.level;
                  return XoCard(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    borderColor: isUnlocked ? ComicColors.green : null,
                    backgroundColor: isUnlocked
                        ? ComicColors.green.withValues(alpha: 0.08)
                        : ComicColors.cream,
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isUnlocked
                                ? ComicColors.green.withValues(alpha: 0.2)
                                : ComicColors.grey.withValues(alpha: 0.15),
                            border: Border.all(color: ComicColors.black, width: 2),
                          ),
                          child: Icon(
                            isUnlocked ? Icons.check_circle : Icons.lock,
                            color: isUnlocked ? ComicColors.green : ComicColors.grey,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'المستوى ${reward.level}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: isUnlocked ? ComicColors.black : ComicColors.grey,
                                ),
                              ),
                              Text(
                                reward.description,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isUnlocked ? ComicColors.grey : ComicColors.grey.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isUnlocked
                                ? ComicColors.green
                                : ComicColors.grey.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: ComicColors.black, width: 2),
                          ),
                          child: Text(
                            isUnlocked ? 'متاح' : 'مغلق',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: ComicColors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}
