import 'package:flutter/material.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';
import 'package:game_show_app/presentation/widgets/common/xo_avatar.dart';
import 'package:game_show_app/presentation/widgets/common/xo_card.dart';

class XoLeaderboardTile extends StatelessWidget {
  final String playerName;
  final String? avatarUrl;
  final int rank;
  final int score;
  final int wins;
  final int gamesPlayed;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;

  const XoLeaderboardTile({
    super.key,
    required this.playerName,
    this.avatarUrl,
    required this.rank,
    required this.score,
    this.wins = 0,
    this.gamesPlayed = 0,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final isTop3 = rank <= 3;
    return XoCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      onTap: onTap,
      backgroundColor: backgroundColor ??
          (isTop3 ? _getMedalColor(rank).withValues(alpha: 0.15) : ComicColors.white),
      borderColor: borderColor,
      child: Row(
        children: [
          if (isTop3)
            Text(_getMedal(rank), style: const TextStyle(fontSize: 24))
          else
            CircleAvatar(
              radius: 14,
              backgroundColor: ComicColors.black,
              child: Text('$rank', style: const TextStyle(
                fontWeight: FontWeight.w900, fontSize: 13, color: ComicColors.white)),
            ),
          const SizedBox(width: 12),
          XoAvatar(imageUrl: avatarUrl, name: playerName, size: 36),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(playerName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                if (gamesPlayed > 0)
                  Text('$wins فوز / $gamesPlayed لعبة', style: const TextStyle(fontSize: 12, color: ComicColors.grey)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$score', style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: ComicColors.black,
              )),
              const Text('نقطة', style: TextStyle(fontSize: 10, color: ComicColors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  String _getMedal(int rank) {
    switch (rank) {
      case 1: return '🥇';
      case 2: return '🥈';
      case 3: return '🥉';
      default: return '';
    }
  }

  Color _getMedalColor(int rank) {
    switch (rank) {
      case 1: return ComicColors.yellow;
      case 2: return ComicColors.grey;
      case 3: return ComicColors.orange;
      default: return ComicColors.grey;
    }
  }
}
