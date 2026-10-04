import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:game_show_app/presentation/providers/auth_provider.dart';
import 'package:game_show_app/presentation/providers/leaderboard_provider.dart';
import 'package:game_show_app/presentation/widgets/common/xo_loading.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  String _selectedPeriod = 'weekly';

  void _setPeriod(String period) {
    if (period != _selectedPeriod) setState(() => _selectedPeriod = period);
  }

  @override
  Widget build(BuildContext context) {
    final leaderboardAsync = ref.watch(leaderboardProvider(_selectedPeriod));
    final currentUser = ref.watch(authStateProvider).value;

    const periodMap = {'weekly': '📅 أسبوعي', 'monthly': '🗓️ شهري', 'allTime': '🏆 كل الوقت'};

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5CC),
      appBar: AppBar(
        backgroundColor: ComicColors.orange,
        elevation: 0,
        title: const Text('🏆 لوحة المتصدرين', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 20)),
        shape: const Border(bottom: BorderSide(color: ComicColors.black, width: 3)),
      ),
      body: ComicBackground(
        bgColor: const Color(0xFFFFF5CC),
        dotColor: ComicColors.orange,
        child: Column(
          children: [
            // Period selector
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: periodMap.entries.map((e) {
                  final isSelected = _selectedPeriod == e.key;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () => _setPeriod(e.key),
                      child: ComicTag(
                        label: e.value,
                        color: isSelected ? ComicColors.orange : Colors.white,
                        textColor: isSelected ? Colors.white : ComicColors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            // Leaderboard list
            Expanded(
              child: leaderboardAsync.when(
                loading: () => const Center(child: XoLoading(message: 'جاري تحميل المتصدرين...')),
                error: (e, _) => Center(
                  child: ComicCard(
                    color: ComicColors.red,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('😕', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 12),
                        const Text('خطأ في التحميل', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 18)),
                        const SizedBox(height: 12),
                        ComicButton(
                          label: '↺ حاول مرة ثانية',
                          color: Colors.white,
                          onTap: () => ref.invalidate(leaderboardProvider(_selectedPeriod)),
                        ),
                      ],
                    ),
                  ),
                ),
                data: (entries) {
                  if (entries.isEmpty) {
                    return Center(
                      child: ComicCard(
                        color: ComicColors.yellow,
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('🏆', style: TextStyle(fontSize: 64)),
                            SizedBox(height: 12),
                            Text('لا يوجد متصدرين بعد!', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: ComicColors.black)),
                            SizedBox(height: 4),
                            Text('العب أول مباراة لتظهر في اللوحة 🚀', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    );
                  }
                  const rankEmojis = ['🥇', '🥈', '🥉'];
                  const rankColors = [ComicColors.yellow, Color(0xFFDDDDDD), Color(0xFFE8A87C)];
                  return RefreshIndicator(
                    onRefresh: () async => ref.invalidate(leaderboardProvider(_selectedPeriod)),
                    color: ComicColors.orange,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        final isCurrentUser = entry.userId == currentUser?.id;
                        final isTop3 = index < 3;
                        final cardColor = isCurrentUser
                          ? ComicColors.blue
                          : (isTop3 ? rankColors[index] : Colors.white);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ComicCard(
                            color: cardColor,
                            shadowOffset: isTop3 ? 6 : 4,
                            child: Row(
                              children: [
                                Text(
                                  isTop3 ? rankEmojis[index] : '#${index + 1}',
                                  style: TextStyle(fontSize: isTop3 ? 28 : 18, fontWeight: FontWeight.w900),
                                ),
                                const SizedBox(width: 12),
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: ComicColors.black,
                                  backgroundImage: entry.photoUrl != null ? NetworkImage(entry.photoUrl!) : null,
                                  child: entry.photoUrl == null
                                    ? Text(entry.displayName.isNotEmpty ? entry.displayName[0].toUpperCase() : '?',
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900))
                                    : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(entry.displayName,
                                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15,
                                          color: isCurrentUser ? Colors.white : ComicColors.black)),
                                      Text('${entry.gamesPlayed} لعبة | ${entry.wins} فوز',
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                                          color: isCurrentUser ? Colors.white70 : Colors.black54)),
                                    ],
                                  ),
                                ),
                                ComicScoreChip(
                                  score: entry.score,
                                  color: isCurrentUser ? Colors.white : ComicColors.blue,
                                ),
                              ],
                            ),
                          ).animate().fadeIn(delay: (index * 60).ms).slideX(begin: 0.1, end: 0),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
