import 'package:flutter/material.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';
import 'package:game_show_app/presentation/widgets/common/xo_card.dart';
import 'package:game_show_app/data/models/gamification/daily_challenge_model.dart';

class ChallengeCard extends StatelessWidget {
  final DailyChallengeModel challenge;
  final VoidCallback? onClaim;

  const ChallengeCard({
    super.key,
    required this.challenge,
    this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    final bool isComplete = challenge.progress >= challenge.requiredAmount;
    final double fraction = challenge.progressFraction;

    return XoCard(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      backgroundColor: ComicColors.white,
      borderColor: isComplete ? ComicColors.green : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _iconForChallenge(),
                color: isComplete ? ComicColors.green : ComicColors.orange,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.title['ar'] ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: ComicColors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      challenge.description['ar'] ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        color: ComicColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
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
                value: fraction,
                backgroundColor: ComicColors.cream,
                color: isComplete ? ComicColors.green : ComicColors.yellow,
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '${challenge.progress} / ${challenge.requiredAmount}',
                style: const TextStyle(
                  fontSize: 12,
                  color: ComicColors.grey,
                ),
              ),
              const Spacer(),
              _rewardChip(Icons.star, '${challenge.xpReward}', ComicColors.yellow),
              const SizedBox(width: 8),
              _rewardChip(Icons.monetization_on, '${challenge.coinReward}', ComicColors.orange),
              if (isComplete && !challenge.rewardClaimed && onClaim != null) ...[
                const SizedBox(width: 8),
                TextButton(
                  onPressed: onClaim,
                  style: TextButton.styleFrom(foregroundColor: ComicColors.black, padding: EdgeInsets.zero),
                  child: const Text('استلام', style: TextStyle(fontWeight: FontWeight.w900)),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _rewardChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ComicColors.black, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: ComicColors.black),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 12, color: ComicColors.black, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  IconData _iconForChallenge() {
    switch (challenge.iconName) {
      case 'play_circle':
        return Icons.play_circle;
      case 'quiz':
        return Icons.quiz;
      case 'stars':
        return Icons.stars;
      case 'emoji_events':
        return Icons.emoji_events;
      case 'sports_esports':
        return Icons.sports_esports;
      case 'check_circle':
        return Icons.check_circle;
      case 'military_tech':
        return Icons.military_tech;
      default:
        return Icons.task_alt;
    }
  }
}
