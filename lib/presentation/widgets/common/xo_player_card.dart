import 'package:flutter/material.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';
import 'package:game_show_app/presentation/widgets/common/xo_avatar.dart';
import 'package:game_show_app/presentation/widgets/common/xo_card.dart';
import 'package:game_show_app/presentation/widgets/common/xo_score_display.dart';

class XoPlayerCard extends StatelessWidget {
  final String name;
  final int score;
  final int yellowCards;
  final int redCards;
  final int rank;
  final bool isWinner;
  final bool isCurrentPlayer;
  final bool isInteractive;
  final VoidCallback? onPlus;
  final VoidCallback? onMinus;
  final VoidCallback? onLongPress;

  const XoPlayerCard({
    super.key,
    required this.name,
    required this.score,
    this.yellowCards = 0,
    this.redCards = 0,
    this.rank = 0,
    this.isWinner = false,
    this.isCurrentPlayer = false,
    this.isInteractive = false,
    this.onPlus,
    this.onMinus,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return XoCard(
      elevation: isWinner ? 4 : 2,
      backgroundColor: isWinner ? ComicColors.green.withValues(alpha: 0.15) : ComicColors.white,
      borderColor: isWinner ? ComicColors.green : null,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.symmetric(vertical: 4),
      onTap: isInteractive ? null : null,
      onLongPress: onLongPress,
      child: Row(
        children: [
          if (rank > 0)
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isWinner ? ComicColors.yellow : ComicColors.grey.withValues(alpha: 0.3),
                border: Border.all(color: ComicColors.black, width: 1.5),
              ),
              child: Center(
                child: Text('$rank', style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: ComicColors.black,
                  fontSize: 13,
                )),
              ),
            ),
          if (rank > 0) const SizedBox(width: 8),
          XoAvatar(name: name, size: 36, isOnline: isCurrentPlayer),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15), overflow: TextOverflow.ellipsis),
                Row(
                  children: [
                    if (yellowCards > 0) ...[
                      Icon(Icons.square_rounded, color: Colors.yellow.shade700, size: 16),
                      if (yellowCards > 1) Text(' $yellowCards', style: TextStyle(fontSize: 11, color: Colors.yellow.shade700)),
                      const SizedBox(width: 4),
                    ],
                    if (redCards > 0) ...[
                      Icon(Icons.square_rounded, color: Colors.red.shade700, size: 16),
                      if (redCards > 1) Text(' $redCards', style: TextStyle(fontSize: 11, color: Colors.red.shade700)),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (isInteractive) ...[
            IconButton(
              icon: Icon(Icons.remove_circle_outline, color: ComicColors.grey, size: 24),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: onMinus,
            ),
            const SizedBox(width: 8),
          ],
          XoScoreDisplay(score: score, fontSize: 20, showIcon: false),
          if (isInteractive) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.add_circle_outline, color: ComicColors.grey, size: 24),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: onPlus,
            ),
          ],
        ],
      ),
    );
  }
}
