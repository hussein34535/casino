import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:game_show_app/core/theme/app_theme.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';
import 'package:game_show_app/features/game_modes.dart';
import 'package:game_show_app/presentation/widgets/common/xo_card.dart';

class GameModeSelectScreen extends StatelessWidget {
  const GameModeSelectScreen({super.key});

  static const Map<GameMode, IconData> _modeIcons = {
    GameMode.classic: Icons.sports_esports,
    GameMode.duel: Icons.people,
    GameMode.speedrun: Icons.bolt,
    GameMode.survival: Icons.favorite,
    GameMode.bossBattle: Icons.whatshot,
  };

  static const Map<GameMode, List<Color>> _modeGradients = {
    GameMode.classic: [Color(0xFF0066FF), Color(0xFF00C2FF)],
    GameMode.duel: [Color(0xFF00D26A), Color(0xFF0066FF)],
    GameMode.speedrun: [Color(0xFFFF6B00), Color(0xFFFFD600)],
    GameMode.survival: [Color(0xFF8B2BE2), Color(0xFFFF3DDD)],
    GameMode.bossBattle: [Color(0xFFFF1F4B), Color(0xFFFF6B00)],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختر طور اللعب'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('اختر طريقة لعبك المفضلة',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: ComicColors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: GameMode.values.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final mode = GameMode.values[index];
                  final config = GameModeConfig.defaults[mode]!;
                  final gradient = _modeGradients[mode]!;
                  final icon = _modeIcons[mode]!;

                  return XoCard(
                    padding: const EdgeInsets.all(16),
                    gradientColors: [gradient[0].withValues(alpha: 0.15), gradient[1].withValues(alpha: 0.05)],
                    borderColor: gradient[0].withValues(alpha: 0.3),
                    borderRadius: 16,
                    onTap: () => context.push('/game-select'),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(icon, color: AppColors.white, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(mode.nameAr,
                                style: const TextStyle(color: ComicColors.black, fontWeight: FontWeight.w900, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(mode.description,
                                style: TextStyle(color: ComicColors.grey, fontSize: 12),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.yellow.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('${config.questionCount} سؤال',
                            style: const TextStyle(color: ComicColors.black, fontSize: 12, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
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
