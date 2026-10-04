import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:game_show_app/data/models/game/player_model.dart';
import 'package:game_show_app/presentation/providers/game_provider.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';

class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameNotifier = ref.read(gameStateProvider.notifier);
    final rankedPlayers = gameNotifier.getRankedPlayers();
    final highestScore = rankedPlayers.isNotEmpty ? rankedPlayers.first.score : 0;

    void goHome() {
      gameNotifier.resetGame();
      if (context.mounted) context.go('/home');
    }

    const rankEmojis = ['🥇', '🥈', '🥉'];
    const rankColors = [ComicColors.yellow, Color(0xFFCCCCCC), Color(0xFFCD7F32)];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) { if (!didPop) goHome(); },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFBE6),
        appBar: AppBar(
          backgroundColor: ComicColors.green,
          elevation: 0,
          title: const Text('🏆 النتائج!', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 22)),
          automaticallyImplyLeading: false,
          shape: const Border(bottom: BorderSide(color: ComicColors.black, width: 3)),
        ),
        body: ComicBackground(
          bgColor: const Color(0xFFFFFBE6),
          dotColor: ComicColors.yellow,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Big bouncing trophy
                if (rankedPlayers.isNotEmpty)
                  Column(
                    children: [
                      const Text('🏆', style: TextStyle(fontSize: 80))
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .scale(duration: 1.seconds, curve: Curves.elasticOut, begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1)),
                      const SizedBox(height: 8),
                      ComicCard(
                        color: ComicColors.yellow,
                        shadowOffset: 5,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        child: Text(
                          'الفائز: ${rankedPlayers.first.name}! 🎉',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: ComicColors.black),
                          textAlign: TextAlign.center,
                        ),
                      ).animate().scale(duration: 700.ms, curve: Curves.elasticOut),
                    ],
                  ),
                const SizedBox(height: 20),
                // Ranking list
                Expanded(
                  child: ListView.builder(
                    itemCount: rankedPlayers.length,
                    itemBuilder: (context, index) {
                      final player = rankedPlayers[index];
                      final isWinner = player.score == highestScore;
                      final cardColor = index < 3 ? rankColors[index] : ComicColors.white;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ComicCard(
                          color: cardColor,
                          shadowOffset: isWinner ? 7 : 5,
                          child: Row(
                            children: [
                              Text(
                                index < 3 ? rankEmojis[index] : '${index + 1}.',
                                style: const TextStyle(fontSize: 28),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  player.name,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: ComicColors.black),
                                ),
                              ),
                              ComicScoreChip(
                                score: player.score,
                                color: isWinner ? ComicColors.green : ComicColors.blue,
                              ),
                            ],
                          ),
                        ).animate().fadeIn(delay: (index * 100).ms).slideY(begin: 0.15, end: 0),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ComicButton(
                  label: '🔄 العب مرة ثانية!',
                  color: ComicColors.green,
                  textColor: Colors.white,
                  onTap: goHome,
                  shadowOffset: 6,
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => SharePlus.instance.share(ShareParams(text: _buildShareText(rankedPlayers))),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.share_rounded, size: 20, color: ComicColors.blue),
                      SizedBox(width: 8),
                      Text('شارك النتيجة! 📣', style: TextStyle(fontWeight: FontWeight.w900, color: ComicColors.blue, fontSize: 15)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _buildShareText(List<LocalPlayer> rankedPlayers) {
  final sb = StringBuffer();
  sb.writeln('🎮 نتائج XO Game Show!');
  sb.writeln('══════════════════');
  for (var i = 0; i < rankedPlayers.length; i++) {
    final p = rankedPlayers[i];
    final medal = i == 0 ? '🥇' : (i == 1 ? '🥈' : (i == 2 ? '🥉' : '${i + 1}.'));
    sb.writeln('$medal ${p.name}: ${p.score} نقطة');
  }
  sb.writeln('══════════════════');
  sb.write('حمّل التطبيق والعب مع أصدقائك! 🚀');
  return sb.toString();
}
