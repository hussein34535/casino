import 'package:flutter/material.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';
import 'package:game_show_app/presentation/widgets/common/xo_card.dart';

enum TierState { locked, unlocked, claimed }

class BattlePassTier extends StatelessWidget {
  final int level;
  final String freeReward;
  final String? premiumReward;
  final TierState state;
  final bool isPremium;
  final VoidCallback? onClaim;
  final VoidCallback? onPurchasePremium;

  const BattlePassTier({
    super.key,
    required this.level,
    required this.freeReward,
    this.premiumReward,
    this.state = TierState.locked,
    this.isPremium = false,
    this.onClaim,
    this.onPurchasePremium,
  });

  @override
  Widget build(BuildContext context) {
    final bool canClaim = state == TierState.unlocked;
    final bool isClaimed = state == TierState.claimed;

    return XoCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      backgroundColor: isClaimed
          ? ComicColors.green.withValues(alpha: 0.1)
          : canClaim
              ? ComicColors.yellow.withValues(alpha: 0.2)
              : ComicColors.white,
      borderColor: canClaim
          ? ComicColors.black
          : isClaimed
              ? ComicColors.green
              : null,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: canClaim
                  ? ComicColors.yellow
                  : isClaimed
                      ? ComicColors.green
                      : ComicColors.grey.withValues(alpha: 0.3),
              border: Border.all(color: ComicColors.black, width: 2),
            ),
            child: Center(
              child: Text(
                '$level',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: canClaim || isClaimed ? ComicColors.black : ComicColors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.card_giftcard, size: 16, color: ComicColors.orange),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(freeReward,
                          style: const TextStyle(fontSize: 13, color: ComicColors.black)),
                    ),
                  ],
                ),
                if (premiumReward != null || !isPremium) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        isPremium ? Icons.workspace_premium : Icons.lock,
                        size: 16,
                        color: isPremium ? ComicColors.orange : ComicColors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          premiumReward ?? 'مكافأة بريميوم',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isPremium ? FontWeight.w900 : FontWeight.normal,
                            color: isPremium ? ComicColors.orange : ComicColors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (canClaim && onClaim != null)
            TextButton(
              onPressed: onClaim,
              style: TextButton.styleFrom(foregroundColor: ComicColors.blue),
              child: const Text('استلام', style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          if (!isPremium && premiumReward != null && onPurchasePremium != null)
            TextButton(
              onPressed: onPurchasePremium,
              style: TextButton.styleFrom(foregroundColor: ComicColors.orange),
              child: const Text('بريميوم', style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          if (isClaimed)
            const Icon(Icons.check_circle, color: ComicColors.green, size: 24),
        ],
      ),
    );
  }
}
