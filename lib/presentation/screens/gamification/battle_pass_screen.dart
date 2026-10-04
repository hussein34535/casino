import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';
import 'package:game_show_app/presentation/providers/gamification_provider.dart';
import 'package:game_show_app/presentation/widgets/common/xo_battle_pass_tier.dart';
import 'package:game_show_app/presentation/widgets/common/xo_card.dart';
import 'package:game_show_app/presentation/widgets/common/xo_loading.dart';

class BattlePassScreen extends ConsumerWidget {
  const BattlePassScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seasonAsync = ref.watch(battlePassProvider);

    return Scaffold(
      backgroundColor: ComicColors.cream,
      appBar: AppBar(
        backgroundColor: ComicColors.orange,
        title: const Text('بطاقة المعركة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)),
        shape: const Border(bottom: BorderSide(color: ComicColors.black, width: 3)),
      ),
      body: seasonAsync.when(
        loading: () => const XoLoading(),
        error: (e, _) => XoErrorWidget(message: 'خطأ: $e'),
        data: (battlePass) {
          if (battlePass == null) {
            return const XoEmptyState(title: 'لم يتم العثور على بطاقة معركة');
          }

          final int currentLevel = battlePass.level;
          final int maxLevel = 50;
          final double progress = currentLevel / maxLevel;

          return Directionality(
            textDirection: TextDirection.rtl,
            child: ListView(
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
                      const Icon(Icons.workspace_premium, size: 48, color: ComicColors.orange),
                      const SizedBox(height: 8),
                      const Text(
                        'الموسم الأول',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: ComicColors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'المستوى $currentLevel',
                        style: const TextStyle(fontSize: 14, color: ComicColors.grey),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: ComicColors.black, width: 2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: ComicColors.cream,
                            color: ComicColors.yellow,
                            minHeight: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$currentLevel / $maxLevel',
                        style: const TextStyle(fontSize: 12, color: ComicColors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'المستويات',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: ComicColors.black,
                  ),
                ),
                const SizedBox(height: 8),
                ...List.generate(
                  maxLevel,
                  (i) {
                    final level = i + 1;
                    final TierState state;
                    if (level < currentLevel) {
                      state = TierState.claimed;
                    } else if (level == currentLevel) {
                      state = TierState.unlocked;
                    } else {
                      state = TierState.locked;
                    }
                    return BattlePassTier(
                      level: level,
                      freeReward: level % 5 == 0 ? 'جائزة خاصة' : '50 عملة',
                      premiumReward: level % 3 == 0 ? 'جائزة بريميوم' : null,
                      state: state,
                      isPremium: battlePass.isPremium,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
