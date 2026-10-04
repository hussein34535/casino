import 'package:flutter/material.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';
import 'package:game_show_app/presentation/widgets/common/xo_card.dart';
import 'package:game_show_app/presentation/widgets/common/xo_score_display.dart';

class XoAchievementTile extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final int progress;
  final int requiredProgress;
  final int? xpReward;
  final int? coinReward;
  final bool isUnlocked;
  final bool isHidden;
  final VoidCallback? onTap;
  final Color? accentColor;

  const XoAchievementTile({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.progress,
    required this.requiredProgress,
    this.xpReward,
    this.coinReward,
    this.isUnlocked = false,
    this.isHidden = false,
    this.onTap,
    this.accentColor,
  });

  const XoAchievementTile.locked({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.progress,
    required this.requiredProgress,
    this.xpReward,
    this.onTap,
  }) : coinReward = null,
       isUnlocked = false,
       isHidden = false,
       accentColor = null;

  const XoAchievementTile.unlocked({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.xpReward,
    this.coinReward,
    this.onTap,
  }) : progress = 0,
       requiredProgress = 0,
       isUnlocked = true,
       isHidden = false,
       accentColor = ComicColors.orange;

  @override
  Widget build(BuildContext context) {
    final progressFraction = requiredProgress > 0
        ? (progress / requiredProgress).clamp(0.0, 1.0)
        : (isUnlocked ? 1.0 : 0.0);
    final color = isUnlocked
        ? (accentColor ?? ComicColors.orange)
        : ComicColors.grey;

    return XoCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      backgroundColor: ComicColors.white,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ComicColors.black, width: 2),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isHidden && !isUnlocked ? '???' : title,
                  style: TextStyle(
                    color: isUnlocked ? ComicColors.black : ComicColors.grey,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isHidden && !isUnlocked ? 'اكشف التحدي' : description,
                  style: const TextStyle(
                    color: ComicColors.grey,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (!isUnlocked && requiredProgress > 0) ...[
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progressFraction,
                      backgroundColor: ComicColors.cream,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 4,
                    ),
                  ),
                  Text(
                    '$progress / $requiredProgress',
                    style: const TextStyle(color: ComicColors.grey, fontSize: 10),
                  ),
                ],
              ],
            ),
          ),
          if (xpReward != null || coinReward != null) ...[
            const SizedBox(width: 8),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (xpReward != null)
                  XoBadge.purple(label: '+$xpReward'),
                if (coinReward != null) ...[
                  const SizedBox(height: 4),
                  XoBadge.yellow(label: '+$coinReward'),
                ],
              ],
            ),
          ],
          if (isUnlocked) ...[
            const SizedBox(width: 8),
            const Icon(Icons.check_circle, color: ComicColors.green, size: 24),
          ],
        ],
      ),
    );
  }
}
