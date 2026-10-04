import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';
import 'package:game_show_app/presentation/providers/gamification_provider.dart';
import 'package:game_show_app/presentation/widgets/common/xo_card.dart';
import 'package:game_show_app/presentation/widgets/common/xo_challenge_card.dart';
import 'package:game_show_app/presentation/widgets/common/xo_loading.dart';

class DailyChallengesScreen extends ConsumerWidget {
  const DailyChallengesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyAsync = ref.watch(dailyChallengesProvider);
    final weeklyAsync = ref.watch(weeklyChallengesProvider);
    final monthlyAsync = ref.watch(monthlyChallengesProvider);

    return Scaffold(
      backgroundColor: ComicColors.cream,
      appBar: AppBar(
        backgroundColor: ComicColors.red,
        title: const Text('التحديات', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)),
        shape: const Border(bottom: BorderSide(color: ComicColors.black, width: 3)),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(dailyChallengesProvider.future),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.today, color: ComicColors.orange, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'التحديات اليومية',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: ComicColors.black,
                      ),
                    ),
                  ],
                ),
              ),
              dailyAsync.when(
                loading: () => const XoShimmerLoading(itemCount: 3),
                error: (e, _) => XoErrorWidget(message: 'خطأ: $e'),
                data: (challenges) {
                  if (challenges.isEmpty) {
                    return const XoEmptyState(title: 'لا توجد تحديات اليوم');
                  }
                  return Column(
                    children: challenges.map((c) => ChallengeCard(challenge: c)).toList(),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.date_range, color: ComicColors.orange, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'التحديات الأسبوعية',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: ComicColors.black,
                      ),
                    ),
                  ],
                ),
              ),
              weeklyAsync.when(
                loading: () => const XoShimmerLoading(itemCount: 3),
                error: (e, _) => XoErrorWidget(message: 'خطأ: $e'),
                data: (challenges) {
                  if (challenges.isEmpty) {
                    return const XoEmptyState(title: 'لا توجد تحديات أسبوعية');
                  }
                  return Column(
                    children: challenges.map((c) => ChallengeCard(challenge: c)).toList(),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.calendar_month, color: ComicColors.purple, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'التحديات الشهرية',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: ComicColors.black,
                      ),
                    ),
                  ],
                ),
              ),
              monthlyAsync.when(
                loading: () => const XoShimmerLoading(itemCount: 1),
                error: (e, _) => XoErrorWidget(message: 'خطأ: $e'),
                data: (challenges) {
                  if (challenges.isEmpty) {
                    return const XoEmptyState(title: 'لا توجد تحديات شهرية');
                  }
                  return Column(
                    children: challenges.map((c) => ChallengeCard(challenge: c)).toList(),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.emoji_events, color: ComicColors.green, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'المكافآت',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: ComicColors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const XoCard(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    _StreakRewardRow(day: 3, reward: '50 عملة', icon: Icons.monetization_on, claimed: false),
                    _StreakRewardRow(day: 7, reward: '200 XP', icon: Icons.star, claimed: false),
                    _StreakRewardRow(day: 14, reward: 'شخصية نادرة', icon: Icons.face, claimed: true),
                    _StreakRewardRow(day: 30, reward: 'وسام المثابر', icon: Icons.military_tech, claimed: false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StreakRewardRow extends StatelessWidget {
  final int day;
  final String reward;
  final IconData icon;
  final bool claimed;

  const _StreakRewardRow({
    required this.day,
    required this.reward,
    required this.icon,
    this.claimed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: claimed ? ComicColors.green : ComicColors.yellow,
              border: Border.all(color: ComicColors.black, width: 2),
            ),
            child: Icon(icon, size: 18, color: ComicColors.black),
          ),
          const SizedBox(width: 12),
          Text('اليوم $day', style: const TextStyle(color: ComicColors.black, fontWeight: FontWeight.w900)),
          const Spacer(),
          Text(reward, style: const TextStyle(color: ComicColors.black, fontWeight: FontWeight.w800)),
          const SizedBox(width: 8),
          Icon(
            claimed ? Icons.check_circle : Icons.circle_outlined,
            color: claimed ? ComicColors.green : ComicColors.grey,
            size: 20,
          ),
        ],
      ),
    );
  }
}
